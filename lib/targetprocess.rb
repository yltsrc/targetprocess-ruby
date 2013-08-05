require 'targetprocess/version'
require 'targetprocess/configuration'
require 'targetprocess/errors'
require 'targetprocess/api_client'
require 'targetprocess/entity_commons'
require 'targetprocess/entities_initializer'

module Targetprocess

  def self.configuration
    msg = "Targetprocess is not configured yet"
    @configuration || raise(Targetprocess::Errors::ConfigurationError.new(msg))
  end

  def self.client
    @client ||= APIClient.new
  end

  def self.configure
    @configuration ||= Configuration.new
    yield(@configuration)
    @client ||= APIClient.new
  end

end
