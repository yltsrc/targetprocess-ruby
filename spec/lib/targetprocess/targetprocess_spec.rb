require 'spec_helper'

describe Targetprocess, vcr: true do
  before :all do
    Targetprocess.configure do |config|
      config.api_url = 'http://tpruby.tpondemand.com/api/v1/'
      config.username = 'admin'
      config.password = 'admin'
    end
  end

  describe ".context" do
    it "return global context" do
      global_acid = "5FCD2783A543047AD90BB28A50EC2152"
      expect(Targetprocess.context[:acid]).to_not be_nil
    end

    it "return context by ids" do
      ids = [1705, 1706]
      expect(Targetprocess.context(ids: ids)[:acid]).to_not be_nil
    end    

    it "return context by single id" do
      ids = 1705
      expect(Targetprocess.context(ids: ids)[:acid]).to_not be_nil
    end

    it "return context by acid" do
      acid = "2D2F0BA211357509A03167EECB5F3456"
      expect(Targetprocess.context(acid: acid)[:acid]).to_not be_nil
    end

    it "return context by acid and ids" do
      acid = "2D2F0BA211357509A03167EECB5F3456"
      ids = [1705, 1706]
      expect(Targetprocess.context(acid: acid, ids: ids)[:acid]).to_not be_nil
    end
  end
end
