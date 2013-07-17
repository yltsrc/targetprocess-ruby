require 'spec_helper.rb'

describe Targetprocess do
  describe '#configure' do
    context "should be difined" do
      it { expect(Targetprocess).to respond_to(:configure)}
    end

    context "should set the attributes" do 
      it do
        Targetprocess.configure do |c|
          c.domain = "domain"
          c.username = "admin"
          c.password = "secret"
        end
        result =Targetprocess.configuration
        expect(result.domain).to eq("domain") 
        expect(result.username).to eq("admin") 
        expect(result.password).to eq("secret") 
      end
    end
    
  end  
end
