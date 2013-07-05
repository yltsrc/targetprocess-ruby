
module Targetprocess
	class Userstory
	
		def initialize(hash)
 			hash_to_story(hash)
 			self.normalize_values
    end

    FLOAT_VAR = %w( effort effortcompleted efforttodo initialestimate numericpriority timeremain timespent )
    INT_VAR = %w( owner_id entitytype_id id entitystate_id priority_id project_id release_id )
    DATE_VAR = %w(createdate enddate lastcommentdate modifydate startdate)
    ALL_VAR = [:id, :description, :name, :createdate, :modifydate, :startdate, :enddate, :lastcommentdate, :tags, :numericpriority, :effort, :effortcompleted, :efforttodo, :timespent, :timeremain, :initialestimate, :entitytype_id, :entitytype_name, :owner_id, :owner_firstname, :owner_lastname, :lastcommenteduser, :project_id, :project_name, :release_id, :release_name, :iteration, :teamiteration, :team, :priority_id, :priority_name, :entitystate_id, :entitystate_name, :feature, :customfields]
	
		def hash_to_story(hash) # todo replace to module 
			hash.each do |k,v|
				if v.is_a?(Hash)
					v.each do |nk,nv|					
						self.instance_variable_set("@#{k.downcase}_#{nk.downcase}", nv)
						self.class.send(:define_method, "#{k.downcase}_#{nk.downcase}", proc{self.instance_variable_get("@#{k.downcase}_#{nk.downcase}")})
						self.class.send(:define_method, "#{k.downcase}_#{nk.downcase}=", proc{|nv| self.instance_variable_set("@#{k.downcase}_#{nk.downcase}", nv)})
					end
					next
				end	
	      self.instance_variable_set("@#{k.downcase}", v)
	      self.class.send(:define_method, k.downcase, proc{self.instance_variable_get("@#{k.downcase}")})
	      self.class.send(:define_method, "#{k.downcase}=", proc{|v| self.instance_variable_set("@#{k.downcase}", v)})
			end
		end

		def normalize_values # todo replace to module 
			(Userstory::FLOAT_VAR + Userstory::INT_VAR + Userstory::DATE_VAR).each do |var|

				val = if self.send(var) == nil
					nil 
				elsif Userstory::FLOAT_VAR.include?(var) 
					self.send(var).to_f
				elsif Userstory::INT_VAR.include?(var)
					self.send(var).to_i
				elsif Userstory::DATE_VAR.include?(var)
					DateTime.iso8601( self.send(var) )
				end
				self.instance_variable_set("@#{var}".to_sym, val) 
			end
		end

		def ==(obj)
			ALL_VAR.each { |var| return self.send(var) == obj.send(var) ? true : false }
		end

	end
end


