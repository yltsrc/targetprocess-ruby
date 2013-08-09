module Targetprocess
  class APIError < StandardError
    class BadRequest < APIError; end
    class NotFound < APIError; end
    class MethodNotAllowed < APIError; end
    class InternalServerError < APIError; end

    def self.parse(response)
      error = response['Error']
      status = error['Status'] || response['Status'] || "Undefined"
      p status
      p self
      p self.constants.include?(status.to_sym)
      self.constants.include?(status.to_sym) ? 
      "#{self}::#{status}".safe_constantize.new(error) : 
      self.new(error.inspect)
    end
  end
end
