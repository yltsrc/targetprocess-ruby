require "yaml"
require 'active_support/inflector'
require 'active_support/concern'
require 'httparty'

module Targetprocess
  module Assignable
    extend ActiveSupport::Concern
   
    ALL_VARS = [:id, :name, :description, :startdate, :enddate, :createdate, 
                :modifydate, :lastcommentdate, :tags, :numericpriority, :effort,
                :effortcompleted, :efforttodo, :timespent, :timeremain, 
                :entitytype, :owner, :lastcommenteduser, :project, :release, 
                :iteration, :teamiteration, :team, :priority, :entitystate,
                :customfields]
    file = File.join(File.dirname(__FILE__), 'missing.yaml')            
    ALL_MISSINGS = YAML::load_file(file)
    
    (ALL_VARS).each { |v| attr_accessor v }

    module ClassMethods 

      def where(params_str,options={})
        options.merge!({:where => params_str})
        self.all(options)
      end

      def all(options={})
        self.find(:all, options)
      end

      def find(id, options={})
        klass = self.to_s.demodulize
        options = {:body => options} 
        case id
        when :all
          url = Targetprocess.configuration.domain + "#{klass.pluralize}"
          response = request(url, options)
          return_array_of response["Items"]          
        else
          url = Targetprocess.configuration.domain + "#{klass.pluralize}/#{id}"
          response = request(url, options)
          self.new response
        end
      end

      def missings
        miss = self::ALL_MISSINGS[self.to_s.demodulize]
        miss.nil? ? [] : miss.collect{ |var| var.to_sym }
      end
      
      def add_accessors(array)
        array.each { |var| attr_accessor var }
      end             

      def error_check(response)
        if response["Error"]
          error = response["Error"]
          type = "Targetprocess::" + error["Status"]  
          msg = error["Message"]
          raise type.constantize , msg
        else
          response
        end 
      end
      
      private 

      def request(url, options={})
        auth = {username: Targetprocess.configuration.username,
                password: Targetprocess.configuration.password }
        default = {:basic_auth => auth, :body => {:format => "json"}}        
        options.merge!(default) { |k,v1,v2| v1.merge(v2)  }
        error_check HTTParty::get(url, options)
      end

      def return_array_of(response)
        response.is_a?(Hash) ? [self.new(response)] : response.collect! do |item| 
          self.new(item) 
        end 
      end
    end

    module InstanceMethods

      def initialize(hash={})
        self.class.add_accessors self.class.missings
        hash_to_obj(hash) 
      end

      def ==(obj)
        (self.class::ALL_VARS+self.class.missings).each  do |var| 
          return false unless self.send(var) == obj.send(var) 
        end
        true
      end
      
      private

      def hash_to_obj(hash) 
        hash.each do |k,v|
          case v 
          when Hash
            v = Hash[v.map {|nk, nv| [nk.downcase.to_sym, nv] }]
          when /Date\((\d*)-(\d*)\)/
            v = Time.at($1.to_i/1000)
          end
          self.instance_variable_set("@#{k.downcase}", v)
        end
      end
    end

  end
end
