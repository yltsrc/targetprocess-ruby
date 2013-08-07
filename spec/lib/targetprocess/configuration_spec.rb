require 'spec_helper'

describe Targetprocess do
  describe '#configure' do
    it 'set targetprocess credentials' do
      Targetprocess.configure do |c|
        c.api_url = 'api_url'
        c.username = 'admin'
        c.password = 'secret'
      end
      config = Targetprocess.configuration

      expect(config).to be_an_instance_of(Targetprocess::Configuration)
      expect(config.api_url).to eql('api_url')
      expect(config.username).to eql('admin')
      expect(config.password).to eql('secret')
    end
  end

  describe "#configuration" do
    it 'raises configuration error if not configured' do
      Targetprocess.instance_variable_set(:"@configuration", nil)
      expect {
        Targetprocess.configuration
      }.to raise_error(Targetprocess::ConfigurationError)
    end


    it 'raises configuration error without username' do
      Targetprocess.configure do |c|
        c.api_url = 'api_url'
        c.username = nil
        c.password = 'secret'
      end
      msg = "There is no username for configuration"

      expect {
        Targetprocess.configuration.username
      }.to raise_error(Targetprocess::ConfigurationError, msg)
    end

    it 'raises configuration error without password' do
      Targetprocess.configure do |c|
        c.api_url = 'api_url'
        c.username = 'admin'
        c.password = nil
      end
      msg = "There is no password for configuration"

      expect {
        Targetprocess.configuration.password
      }.to raise_error(Targetprocess::ConfigurationError, msg)
    end

    it 'raises configuration error without api_url' do
      Targetprocess.configure do |c|
        c.api_url = nil
        c.username = 'admin'
        c.password = 'secret'
      end
      msg = "There is no api_url for configuration"

      expect {
        Targetprocess.configuration.api_url
      }.to raise_error(Targetprocess::ConfigurationError, msg)
    end
  end

  describe "#client" do
    it "returns APIClient instance" do
      endpoint = Targetprocess.client

      expect(endpoint).to be_an_instance_of(Targetprocess::APIClient)
    end 
  end
end
