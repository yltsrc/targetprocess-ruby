require "yaml"
require 'active_support/inflector'
require 'httparty'
require 'oj'

module Targetprocess
  module Assignable
    def self.included(base)
      base.send(:include, InstanceMethods)   
      base.extend(ClassMethods)
      base.define_accessors
    end

    ATTR_FILE = File.join(File.dirname(__FILE__), 'attributes.yml')            
    
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
      
      def define_accessors
        self.attributes["readable"].each { |a| attr_reader a }
        editable = self.attributes["readable"]-self.attributes["unsettable"]
        editable.each {|a| attr_writer a} 
      end
      
      def attributes 
        all_attributes = YAML::load_file(ATTR_FILE)
        class_name = self.to_s.demodulize.downcase
        all_attributes[class_name]    
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

      def save 
        uri = self.class.to_s.demodulize.pluralize
        url = Targetprocess.configuration.domain + uri
        p url
        header = { 'Content-Type' => 'application/json' }
        garbage = "\"^o\":\"#{self}\","
        content = Oj::dump(self, :mode => :compat)
        content.slice!(garbage)
        p content
        self.class.error_check HTTParty::post(url, body: content ,:headers => header)
      end

      def initialize(hash={})
        hash_to_obj(hash) 
      end

      def ==(obj)
        self.class.attributes["readable"].each  do |var| 
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
