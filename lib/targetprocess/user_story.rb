
module Targetprocess
	class Userstory
		self.send(:include, Targetprocess)
		
		def initialize(hash)
 			hash_to_obj(hash)
 			self.normalize_values
    end

    FLOAT_VAR = %w( effort effortcompleted efforttodo initialestimate numericpriority timeremain timespent )
    INT_VAR = %w( owner_id entitytype_id id entitystate_id priority_id project_id release_id lastcommenteduser_id)
    DATE_VAR = %w(createdate enddate lastcommentdate modifydate startdate)
    ALL_VAR = [:id, :description, :name, :createdate, :modifydate, :startdate, :enddate, :lastcommentdate, :tags, :numericpriority, :effort, :effortcompleted, :efforttodo, :timespent, :timeremain, :initialestimate, :entitytype_id, :entitytype_name, :owner_id, :owner_firstname, :owner_lastname, :lastcommenteduser, :project_id, :project_name, :release_id, :release_name, :iteration, :teamiteration, :team, :priority_id, :priority_name, :entitystate_id, :entitystate_name, :feature, :customfields]

		def ==(obj)
			ALL_VAR.each do |var| 
				if obj.respond_to?(var) && self.respond_to?(var)
					return false unless self.send(var) == obj.send(var)  
				end
				return false if obj.respond_to?(var) && !self.respond_to?(var)
				return false if !obj.respond_to?(var) && self.respond_to?(var)
			end
		end

	end
end


