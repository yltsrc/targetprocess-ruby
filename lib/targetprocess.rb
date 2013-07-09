require "targetprocess/version"
require "targetprocess/user_story_resource"
require "targetprocess/user_story"
require "targetprocess/user"
require "targetprocess/task"

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
		klass = self.class
		klass::ALL_VAR.each do |var|
			current_val = self.send(var)
			val = if self.send(var).nil?
				nil 
			elsif klass::FLOAT_VAR.include?(var.to_s) 
				current_val.to_f
			elsif klass::INT_VAR.include?(var.to_s)
				current_val.to_i
			elsif klass::ARR_VAR.include?(var.to_s)
				current_val.is_a?(Array) ? current_val : current_val.split(/, /) 
			elsif klass::DATE_VAR.include?(var.to_s)
				DateTime.parse( current_val )
			elsif current_val.is_a?(Hash)
				Hash[current_val.map {|k, v| [k.downcase.to_sym, (k=="Id"? v.to_i : v) ] }]
			elsif current_val == "true"
				true
			elsif current_val == "false"
				false
			else 
				current_val
			end
			self.instance_variable_set("@#{var}".to_sym, val) 
		end
	end

end
