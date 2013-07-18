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
  include HTTParty
  class << self
    attr_accessor :configuration 
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :domain, :username, :password
  end

end
