require "yaml"
require 'active_support/inflector'
require 'active_support/concern'
require 'httparty'


module Targetprocess
  module Assignable
    extend ActiveSupport::Concern
    
    ARR_VARS = %w( tags skills )
    FLOAT_VARS = %w( velocity weeklyavaolablehours currentavailablehours 
                     availablefuturehours timeremain timespent efforttodo 
                     effortcompleted effort initialestimate )
    INT_VARS = %w( assignable_id responsible_id duration currentallocation 
                   availablefutureallocation role_id id entitystate_id 
                   priority_id team_id teamiteration_id iteration_id release_id 
                   project_id lastcommenteduser_id owner_id entitytype_id 
                   numericpriority userstory_id severity_id build_id 
                   parentid general_id )
    DATE_VARS = %w( lastrundate deletedate availablefrom startdate enddate 
                    createdate modifydate lastcommentdate )
    ALL_VARS = [:id, :name, :description, :startdate, :enddate, :createdate, 
                :modifydate, :lastcommentdate, :tags, :numericpriority, :effort,
                :effortcompleted, :efforttodo, :timespent, :timeremain, 
                :entitytype, :entitytype_id, :entitytype_name, :owner, 
                :owner_id, :owner_firstname, :owner_secondname, 
                :lastcommenteduser, :lastcommenteduser_id, 
                :lastcommenteduser_name, :project, :project_id, :project_id, 
                :project_name, :release, :release_id, :release_name, :iteration,
                :iteration_id, :iteration_name, :teamiteration, 
                :teamiteration_id, :teamiteration_name, :team, :team_id, 
                :team_name, :priority, :priority_id, :priority_name, 
                :entitystate, :entitystate_id, :entitystate_name, :customfields]
    file = File.join(File.dirname(__FILE__), 'missing.yaml')            
    ALL_MISSINGS = YAML::load_file(file)
    
    (ALL_VARS).each { |v| attr_accessor v }

    module ClassMethods 

      def where(params_str)
        options = {:body => {:where => params_str}}
        self.all(options)
      end

      def all(options={})
        self.find(:all, options)
      end

      def find(id, options={})
        klass = self.to_s.split(/::/).last
        case id
        when :all
          url = Targetprocess.configuration.domain + "#{klass.pluralize}"
          response = request(url, options)
          response.nil? ? nil : return_array_of(response[klass.pluralize][klass])
        else
          url = Targetprocess.configuration.domain + "#{klass.pluralize}/#{id}"
          response = request(url, options)
          response.nil? ? nil : response[klass]
        end
      end

      def missings
        miss = self::ALL_MISSINGS[self.to_s.split(/::/).last.downcase]
        miss.nil? ? [] : miss.collect{ |var| var.to_sym }
      end
      
      def add_accessors(array)
        array.each { |var| attr_accessor var }
      end             

      def constants_inclusion(value, var)
        if self::FLOAT_VARS.include?(var.to_s) 
          value.to_f
        elsif self::INT_VARS.include?(var.to_s)
          value.to_i
        elsif self::ARR_VARS.include?(var.to_s)
          value.is_a?(Array) ? value : value.split(/, /) 
        elsif self::DATE_VARS.include?(var.to_s)
          DateTime.parse( value )
        else 
          value
        end
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
        options.merge!(:basic_auth => auth)
        error_check HTTParty::get(url, options)
      end

      def return_array_of(response)
        response.is_a?(Hash) ? [self.new(response)] : response.collect! do |item| 
          self.new(item) 
        end 
      end


    end

    module InstanceMethods

      def initialize(hash)
        self.class.add_accessors self.class.missings
        hash_to_obj(hash)
        self.normalize_values
      end

      def ==(obj)
        (self.class::ALL_VARS+self.class.missings).each  do |var| 
          return false unless self.send(var) == obj.send(var) 
        end
        true
      end
      
      def normalize_values  
        (self.class::ALL_VARS+self.class.missings).each do |var|
          value = self.send(var)
          if self.send(var).nil?
            value = nil 
          else
            value = self.class.constants_inclusion(value, var)
            value = bool_normalize(value)
            value = hash_normalize(value)
          end
          self.instance_variable_set("@#{var}".to_sym, value) 
        end
      end

      private

      def hash_to_obj(hash) 
        hash.each do |k,v|
          if v.is_a?(Hash)
            v.each do |nk,nv|         
              self.instance_variable_set("@#{k.downcase}_#{nk.downcase}", nv)
            end
          end 
          self.instance_variable_set("@#{k.downcase}", v)
        end
      end
      
      def bool_normalize(value)
        if value == "true"
          true
        elsif value == "false"
          false
        else 
          value
        end
      end

      def hash_normalize(value)
        if value.is_a?(Hash)
          Hash[value.map {|k, v| [k.downcase.to_sym, (k=="Id"? v.to_i : v)] }]
        else
          value  
        end
      end

    end

  end
end
