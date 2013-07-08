module Targetprocess
	class User
		self.send(:include, Targetprocess)

		def initialize(hash)
			hash_to_obj(hash)
			# normalize_values	
		end


	end
end
