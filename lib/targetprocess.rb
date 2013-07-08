require "targetprocess/version"
require "targetprocess/user_story_resource"
require "targetprocess/user_story"
require "targetprocess/user"

module Targetprocess

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
		(self.class::ALL_VAR + self.class::FLOAT_VAR + self.class::INT_VAR + self.class::DATE_VAR).each do |var|
				val = if self.send(var).nil?
					nil 
				elsif self.class::FLOAT_VAR.include?(var) 
					self.send(var).to_f
				elsif self.class::INT_VAR.include?(var)
					self.send(var).to_i
				elsif self.class::DATE_VAR.include?(var)
					DateTime.parse( self.send(var) )
				elsif self.send(var).is_a?(Hash)
					Hash[self.send(var).map {|k, v| [k.downcase.to_sym, (k=="Id"? v.to_i : v) ] }]
				else 
					self.send(var)
				end
				self.instance_variable_set("@#{var}".to_sym, val) 
		end
	end
end
