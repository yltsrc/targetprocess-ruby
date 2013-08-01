module Targetprocess

  class Configuration

    attr_writer :domain, :username, :password

    def domain
      msg = "There is no domain for configuration"
      if @domain
        @domain[-1] == "/" ? @domain : @domain + "/" unless @domain.nil?
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
