
module Targetprocess
	class Userstory
		self.send(:include, Targetprocess)
		
		ARR_VAR = %w(tags)
    FLOAT_VAR = %w( effort effortcompleted efforttodo initialestimate numericpriority timeremain timespent )
    INT_VAR = %w( feature_id team_id owner_id iteration_id entitytype_id id entitystate_id priority_id project_id release_id lastcommenteduser_id)
    DATE_VAR = %w(createdate enddate lastcommentdate modifydate startdate)
    ALL_VAR = [:id, :release, :description, :name, :createdate, :modifydate, :startdate, :enddate, :lastcommentdate, :tags, :priority, :numericpriority, :effort, :effortcompleted, :efforttodo, :timespent, :timeremain, :initialestimate, :entitytype, :entitytype_id, :entitytype_name, :owner, :owner_id, :owner_firstname, :owner_lastname, :lastcommenteduser, :project, :project_id, :project_name, :release_id, :release_name, :iteration, :teamiteration,:team_id, :team_name, :team, :priority_id, :priority_name, :iteration_name, :iteration_id, :entitystate_id, :entitystate, :entitystate_name, :feature_id, :feature_name, :feature, :customfields, :lastcommenteduser_id]

		ALL_VAR.each {|v| attr_accessor v}

		def initialize(hash)
			hash_to_obj(hash)
 			self.normalize_values
    end
	
		def ==(obj)
			ALL_VAR.each { |var| return false unless self.send(var) == obj.send(var) }
		end

	end
end


