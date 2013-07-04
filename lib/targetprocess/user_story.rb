
module Targetprocess
	class Userstory
		def initialize(hash)
    	hash.each do |k,v|
	      self.instance_variable_set("@#{k.downcase}", v)
	      self.class.send(:define_method, k.downcase, proc{self.instance_variable_get("@#{k.downcase}")})
	      self.class.send(:define_method, "#{k.downcase}=", proc{|v| self.instance_variable_set("@#{k.downcase}", v)})
	    end
    end
	end
end

