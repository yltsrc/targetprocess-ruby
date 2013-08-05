module Targetprocess

  class Configuration

    attr_writer :api_url, :username, :password

    def api_url
      msg = "There is no api_url for configuration"
      if @api_url
        @api_url[-1] == "/" ? @api_url : @api_url + "/" unless @api_url.nil?
      else
        raise Targetprocess::ConfigurationError.new(msg)
      end
    end

    def username
      msg = "There is no username for configuration"
      @username || raise(Targetprocess::ConfigurationError.new(msg))
    end

    def password
      msg = "There is no password for configuration"
      @password || raise(Targetprocess::ConfigurationError.new(msg))
    end

  end

end
