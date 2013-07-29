module Targetprocess
  class Request

    def self.perform(http, url, options={})
      auth = {username: Targetprocess.configuration.username,
              password: Targetprocess.configuration.password }
      default = {:basic_auth => auth}
      default.merge!(:body => {:format => "json"}) if http ==:get  
      options.merge!(default) { |k,v1,v2| v1.merge(v2)  }
      error_check HTTParty.send(http, url, options)
    end

    private 

    def self.error_check(response)
      if response["Error"]
        error = response["Error"]
        type = "Targetprocess::" + error["Status"]  
        msg = error["Message"]
        raise type.constantize , msg
      else
        response
      end 
    end

  end
end
