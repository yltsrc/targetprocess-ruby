require "yaml"

module Assignable

  def self.included(base)
    base.send(:include, InstanceMethods)
    base.extend ClassMethods
  end  

  ARR_VARS = %w( tags skills )
  FLOAT_VARS = %w( velocity weeklyavaolablehours currentavailablehours availablefuturehours 
                   timeremain timespent efforttodo effortcompleted effort initialestimate)
  INT_VARS = %w( duration currentallocation availablefutureallocation role_id id entitystate_id
                 priority_id team_id teamiteration_id iteration_id release_id project_id 
                 lastcommenteduser_id owner_id entitytype_id numericpriority userstory_id 
                 severity_id build_id )
  DATE_VARS = %w( deletedate availablefrom startdate enddate createdate modifydate lastcommentdate )
  ALL_VARS = [:id, :name , :description, :startdate, :enddate, :createdate, :modifydate, 
              :lastcommentdate, :tags, :numericpriority, :effort, :effortcompleted, 
              :efforttodo, :timespent, :timeremain, :entitytype, :entitytype_id, 
              :entitytype_name, :owner, :owner_id, :owner_firstname, :owner_secondname,
              :lastcommenteduser, :lastcommenteduser_id, :lastcommenteduser_name, 
              :project, :project_id, :project_id, :project_name, :release, :release_id, 
              :release_name, :iteration, :iteration_id, :iteration_name, :teamiteration,
              :teamiteration_id, :teamiteration_name, :team, :team_id, :team_name, 
              :priority, :priority_id, :priority_name, :entitystate, :entitystate_id, 
              :entitystate_name, :customfields]
  ALL_MISSINGS = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'missing.yaml'))
  
  (ALL_VARS).each { |v| attr_accessor v }

  module ClassMethods 

    def add_accessors(array)
      array.each { |var| attr_accessor var }
    end             

    def missings
      self::ALL_MISSINGS[self.to_s.split(/::/).last.downcase].collect{ |var| var.to_sym }
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
