module Targetprocess
  class Task
    self.send(:include, Targetprocess)

    ARR_VAR = %w( tags )
    FLOAT_VAR = %w( timeremain timespent efforttodo effortcompleted effort )
    INT_VAR = %w( id userstory_id entitystate_id priority_id team_id teamiteration_id iteration_id release_id project_id lastcommenteduser_id owner_id entitytype_id numericpriority )
    DATE_VAR = %w( startdate enddate createdate modifydate lastcommentdate )
    ALL_VAR = [:id, :name , :description, :startdate, :enddate, :createdate, :modifydate, :lastcommentdate, :tags, :numericpriority, :effort, :effortcompleted, :efforttodo, :timespent, :timeremain, :entitytype, 
               :entitytype_id, :entitytype_name, :owner, :owner_id, :owner_firstname, :owner_secondname, :lastcommenteduser, :lastcommenteduser_id, :lastcommenteduser_name, :project, :project_id, :project_id, 
               :project_name, :release, :release_id, :release_name, :iteration, :iteration_id, :iteration_name, :teamiteration, :teamiteration_id, :teamiteration_name, :team, :team_id, :team_name, :priority,
               :priority_id, :priority_name, :entitystate, :entitystate_id, :entitystate_name, :userstory, :userstory_id, :userstory_name, :customfields]

    ALL_VAR.each { |v| attr_accessor v }            

    def initialize(hash)
      hash_to_obj(hash)
      self.normalize_values
    end

    def ==(obj)
      ALL_VAR.each { |var| return false unless self.send(var) == obj.send(var) }
    end

  end
end
