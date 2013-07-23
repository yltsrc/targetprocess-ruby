module Targetprocess
  class BadRequest < StandardError; end
  class NotFound < StandardError; end
  class MethodNotAllowed < StandardError; end
  class ConfigurationError < StandardError; end 
end
