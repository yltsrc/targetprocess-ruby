require 'spec_helper.rb'

describe Targetprocess do
  describe '#configure' do
    it 'raises configuration error without domain' do
      Targetprocess.configure do |c|
        c.username = 'admin'
        c.domain = nil
        c.password = 'secret'
      end
      expect {
        Targetprocess.configuration
      }.to raise_error(Targetprocess::ConfigurationError)
    end

    it 'raises configuration error without username' do
      Targetprocess.configure do |c|
        c.domain = 'domain'
        c.username = nil
        c.password = 'secret'
      end
      expect {
        Targetprocess.configuration
      }.to raise_error(Targetprocess::ConfigurationError)
    end

    it 'raises configuration error without password' do
      Targetprocess.configure do |c|
        c.domain = 'domain'
        c.username = 'admin'
        c.password = nil
      end
      expect {
        Targetprocess.configuration
      }.to raise_error(Targetprocess::ConfigurationError)
    end

    it 'set http credentials' do
      Targetprocess.configure do |c|
        c.domain = 'domain'
        c.username = 'admin'
        c.password = 'secret'
      end
      config = Targetprocess.configuration

      expect(config).to be_an_instance_of(Targetprocess::Configuration)
      expect(config.domain).to eql('domain/')
      expect(config.username).to eql('admin')
      expect(config.password).to eql('secret')
    end
  end  
end
