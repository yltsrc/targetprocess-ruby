module Targetprocess
  module Errors
    class UnexpectedApiError < StandardError; end
    class BadRequest < StandardError; end
    class NotFound < StandardError; end
    class MethodNotAllowed < StandardError; end
    class ConfigurationError < StandardError; end
    class InternalServerError < StandardError; end
  end
end
