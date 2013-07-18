require 'spec_helper.rb'

describe Targetprocess do
  describe '#configure' do
    it 'set http credentials' do
      Targetprocess.configure do |c|
        c.domain = 'domain'
        c.username = 'admin'
        c.password = 'secret'
      end
      config = Targetprocess.configuration

      expect(config).to be_an_instance_of(Targetprocess::Configuration)
      expect(config.domain).to eql('domain')
      expect(config.username).to eql('admin')
      expect(config.password).to eql('secret')
    end

    it 'raises configuration error with no credentials' do
      expect {
        Targetprocess.configuration
      }.to raise(Targetprocess::ConfigurationError)
    end
  end  
end
