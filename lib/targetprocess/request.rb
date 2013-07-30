require 'active_support/inflector'

module Targetprocess
  class HTTPRequest

    def self.perform(http, url, options={})
      auth = {username: Targetprocess.configuration.username,
              password: Targetprocess.configuration.password }
      default = {:basic_auth => auth}
      default.merge!(:body => {:format => "json"}) if http ==:get  
      options.merge!(default) { |k,v1,v2| v1.merge(v2)  }
      error_check HTTParty.send(http, url, options)
    end
    
    def self.error_check(response)
      if response["Error"]
        error = response["Error"]
        status = error["Status"] || response["Status"]
        raise ("Targetprocess::" + status).safe_constantize , error["Message"]
      else
        response
      end 
    end

    private_class_method :error_check

  end
end
