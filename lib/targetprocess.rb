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
require "targetprocess/process"
require "targetprocess/priority"
require "targetprocess/severity"
require "targetprocess/entitystate"
require "targetprocess/program"
require "targetprocess/testplan"
require "targetprocess/testplanrun"
require "targetprocess/testcaserun"
require "targetprocess/time"
require "targetprocess/assignment"
require "targetprocess/role"
require "targetprocess/roleeffort"
require "targetprocess/projectmember"

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
