require 'spec_helper'

describe TargetProcess do
  describe '#configure' do
    it 'set targetprocess credentials' do
      TargetProcess.configure do |c|
        c.api_url = 'api_url'
        c.username = 'admin'
        c.password = 'secret'
      end
      config = TargetProcess.configuration

      expect(config).to be_an_instance_of(TargetProcess::Configuration)
      expect(config.api_url).to eql('api_url')
      expect(config.username).to eql('admin')
      expect(config.password).to eql('secret')
    end
  end

  describe "#configuration" do
    it 'raises configuration error if not configured' do
      TargetProcess.instance_variable_set(:"@configuration", nil)
      expect {
        TargetProcess.configuration
      }.to raise_error(TargetProcess::ConfigurationError)
    end


    it 'raises configuration error without username' do
      TargetProcess.configure do |c|
        c.api_url = 'api_url'
        c.username = nil
        c.password = 'secret'
      end
      msg = "There is no username for configuration"

      expect {
        TargetProcess.configuration.username
      }.to raise_error(TargetProcess::ConfigurationError, msg)
    end

    it 'raises configuration error without password' do
      TargetProcess.configure do |c|
        c.api_url = 'api_url'
        c.username = 'admin'
        c.password = nil
      end
      msg = "There is no password for configuration"

      expect {
        TargetProcess.configuration.password
      }.to raise_error(TargetProcess::ConfigurationError, msg)
    end

    it 'raises configuration error without api_url' do
      TargetProcess.configure do |c|
        c.api_url = nil
        c.username = 'admin'
        c.password = 'secret'
      end
      msg = "There is no api_url for configuration"

      expect {
        TargetProcess.configuration.api_url
      }.to raise_error(TargetProcess::ConfigurationError, msg)
    end
  end

  describe "#client" do
    it "returns APIClient instance" do
      endpoint = TargetProcess.client

      expect(endpoint).to be_an_instance_of(TargetProcess::APIClient)
    end
  end
end
