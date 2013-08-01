require 'targetprocess/version'
require 'targetprocess/configuration'
require 'targetprocess/errors'
require 'targetprocess/api_client'
require 'targetprocess/entity_commons'
require 'targetprocess/entities_initializer'

module Targetprocess

  def self.configuration
    msg = "Targetprocess is not configured yet"
    @configuration || raise(Targetprocess::ConfigurationError.new(msg))
  end

  def self.client
    msg = "Targetprocess is not configured yet"
    @client || raise(Targetprocess::ConfigurationError.new(msg))
  end

  def self.configure
    @configuration ||= Configuration.new
    yield(@configuration)
    @client ||= APIClient.new(@configuration)
  end

end
