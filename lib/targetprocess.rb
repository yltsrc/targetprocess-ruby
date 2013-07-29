require "targetprocess/version"
require "targetprocess/errors"
require "targetprocess/entities_initializer"

module Targetprocess
  class << self

    def configuration
      msg = "Targetproces is not configured yet"
      @configuration || raise(Targetprocess::ConfigurationError.new(msg))
    end
  end

  def self.configure
    @configuration ||= Configuration.new
    yield(@configuration)
  end

  class Configuration

    attr_writer :domain, :username, :password

    def password
      msg = "Targetprocess.configuration.password is not specifyed yet please 
            review the README to find out a way to configure Targetprocess"
      @password || raise(Targetprocess::ConfigurationError.new(msg))
    end

    def username 
      msg = "Targetprocess.configuration.username is not specifyed yet please 
            review the README to find out way to configure Targetprocess"
      @username || raise(Targetprocess::ConfigurationError.new(msg))
    end

    def domain 
      msg = "Targetprocess.configuration.domain is not specifyed yet please 
            review the README to find out way to configure Targetprocess"
      if @domain
        @domain[-1] == "/" ? @domain : @domain + "/" unless @domain.nil?
      else
        raise Targetprocess::ConfigurationError.new(msg)
      end
    end

  end

end
