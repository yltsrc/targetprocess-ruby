require 'spec_helper'

describe Targetprocess do
  describe '#configure' do
    it 'raises configuration error if not configured' do
      Targetprocess.instance_variable_set(:"@configuration", nil)
      expect {
        p Targetprocess.configuration
      }.to raise_error(Targetprocess::Errors::ConfigurationError)
    end

    it 'set http credentials' do
      Targetprocess.configure do |c|
        c.api_url = 'api_url'
        c.username = 'admin'
        c.password = 'secret'
      end
      config = Targetprocess.configuration

      expect(config).to be_an_instance_of(Targetprocess::Configuration)
      expect(config.api_url).to eql('api_url/')
      expect(config.username).to eql('admin')
      expect(config.password).to eql('secret')
    end

    it 'setup api client after configuration' do
      Targetprocess.configure do |c|
        c.api_url = 'api_url'
        c.username = 'admin'
        c.password = 'secret'
      end

      client = Targetprocess.client
      expect(client).to be_an_instance_of(Targetprocess::APIClient)
    end

    it 'raises configuration error without username' do
      Targetprocess.configure do |c|
        c.api_url = 'api_url'
        c.username = nil
        c.password = 'secret'
      end

      expect {
        Targetprocess.configuration.username
      }.to raise_error(Targetprocess::Errors::ConfigurationError)
    end

    it 'raises configuration error without password' do
      Targetprocess.configure do |c|
        c.api_url = 'api_url'
        c.username = 'admin'
        c.password = nil
      end

      expect {
        Targetprocess.configuration.password
      }.to raise_error(Targetprocess::Errors::ConfigurationError)
    end

    it 'raises configuration error without api_url' do
      Targetprocess.configure do |c|
        c.api_url = nil
        c.username = 'admin'
        c.password = 'secret'
      end

      expect {
        Targetprocess.configuration.api_url
      }.to raise_error(Targetprocess::Errors::ConfigurationError)
    end
  end

end
