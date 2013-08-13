module TargetProcess
  class Configuration
    attr_writer :api_url, :username, :password

    def api_url
      msg = "There is no api_url for configuration"
      @api_url || raise(TargetProcess::ConfigurationError.new(msg))
    end

    def username
      msg = "There is no username for configuration"
      @username || raise(TargetProcess::ConfigurationError.new(msg))
    end

    def password
      msg = "There is no password for configuration"
      @password || raise(TargetProcess::ConfigurationError.new(msg))
    end
  end
end
