require "targetprocess/version"
require "targetprocess/user_story"
require "targetprocess/user"
require "targetprocess/task"
require "targetprocess/bug"
require "targetprocess/feature"
require "targetprocess/project"
require "targetprocess/release"
require "targetprocess/request"
require "targetprocess/testcase"
require "targetprocess/impediment"
require "targetprocess/iteration"
require "targetprocess/comment"
require "targetprocess/errors"

module Targetprocess
  class << self
    attr_accessor :configuration 

    def configuration
      c = @configuration
      if c.nil? || c.domain.nil? || c.username.nil? || c.password.nil?
        raise Targetprocess::ConfigurationError
      else
        @configuration
      end
    end
  end

  def self.configure
    @configuration ||= Configuration.new
    yield(@configuration)
  end

  class Configuration
    attr_accessor :domain, :username, :password

    def domain 
      @domain[-1] == "/" ? @domain : @domain + "/" unless @domain.nil?
    end
  end

end
