module Targetprocess
	class User
		self.send(:include, Targetprocess)

		ARR_VAR = %w(skills)
		FLOAT_VAR = %w( availablefuturehours currentavailablehours weeklyavailablehours )
		INT_VAR = %w( id role_id currentallocation availablefutureallocation )
		DATE_VAR = %w( createdate modifydate deletedate )
		ALL_VAR = [ :id, :kind, :firstname, :lastname, :email, :login, :createdate, :modifydate, :deletedate, :isactive, :isadministrator, :weeklyavaolablehours, :currentallocation, :currentavailablehours,
							:availablefrom, :availablefutureallocation, :availablefuturehours, :isobserver, :skills, :activedirectoryname, :role_id, :role_name, :role]

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

