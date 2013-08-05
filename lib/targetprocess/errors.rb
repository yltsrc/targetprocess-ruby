module Targetprocess
  module ApiErrors
    class UnexpectedError < StandardError; end
    class BadRequest < StandardError; end
    class NotFound < StandardError; end
    class MethodNotAllowed < StandardError; end
    class InternalServerError < StandardError; end
  end
  class ConfigurationError < StandardError; end
end
