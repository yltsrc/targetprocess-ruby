require "targetprocess/version"
require "targetprocess/user_story_resource"
require "targetprocess/user_story"

module Targetprocess

	def hash_to_obj(hash) 
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

	def normalize_values  
		(self.class::FLOAT_VAR + self.class::INT_VAR + self.class::DATE_VAR).each do |var|
			if self.respond_to? var
				val = if self.send(var) == nil
					nil 
				elsif self.class::FLOAT_VAR.include?(var) 
					self.send(var).to_f
				elsif self.class::INT_VAR.include?(var)
					self.send(var).to_i
				elsif self.class::DATE_VAR.include?(var)
					DateTime.parse( self.send(var) )
				end
				self.instance_variable_set("@#{var}".to_sym, val) if self.respond_to? var.to_sym
			end
		end
	end
end
