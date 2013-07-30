require "targetprocess/version"
require "targetprocess/errors"
require "targetprocess/entities_initializer"

module Targetprocess

  def self.configuration
    msg = "Targetprocess is not configured yet"
    @configuration || raise(Targetprocess::ConfigurationError.new(msg))
  end

  def self.configure
    @configuration ||= Configuration.new
    yield(@configuration)
  end

  class Configuration

    attr_writer :domain, :username, :password

    def password
      msg = "There is no password for configuration"
      @password || raise(Targetprocess::ConfigurationError.new(msg))
    end

    def username 
      msg = "There is no username for configuration"
      @username || raise(Targetprocess::ConfigurationError.new(msg))
    end

    def domain 
      msg = "There is no domain for configuration"
      if @domain
        @domain[-1] == "/" ? @domain : @domain + "/" unless @domain.nil?
      else
        raise Targetprocess::ConfigurationError.new(msg)
      end
    end

  end

end
