require 'spec_helper'
require 'targetprocess/assignable'

  Targetprocess.configure do |config|
    config.domain = "http://kamrad.tpondemand.com/api/v1/"
    config.username = "admin"
    config.password = "admin"
  end

shared_examples "an assignable" do
  let(:assignable) { described_class.find(:all).first}
  context "initialized" do
    it " says it is an instance of #{described_class}" do
      expect(assignable).to be_an_instance_of(described_class)
    end

    describe "it has defined constants" do
      context "ALL_VARS" do
        it { expect(described_class::ALL_VARS).to_not be_nil }
      end
      context "INT_VARS" do
        it { expect(described_class::INT_VARS).to_not be_nil }
      end
      context "FLOAT_VARS" do
        it { expect(described_class::FLOAT_VARS).to_not be_nil }
      end
      context "ARR_VARS" do
        it { expect(described_class::ARR_VARS).to_not be_nil }
      end
      context "DATE_VARS" do
        it { expect(described_class::DATE_VARS).to_not be_nil }
      end
      context "ALL_MISSINGS" do
        it { expect(described_class::ALL_MISSINGS).to_not be_nil }
      end
    end

    describe" it has defined getters" do
      (described_class::ALL_VARS + described_class.missings ).each do |method|
        context do
          it{ expect(assignable).to respond_to(method) } 
        end
      end
    end

    describe ".missings" do
      context do
        it { expect(described_class.missings).to be_an_instance_of(Array) }
      end
    end

    describe ".find" do
      context "id = :all" do
        it { expect(described_class.find(:all)).to be_an_instance_of(Array) }
      end

      context "count for (id = :all, options={body=>{take: 1}})" do
        it { expect(described_class.find(:all, body: {take: 1}).count).to eq(1)}
      end
    end

    describe ".error_check" do
      context "find_with literal id" do
        it { expect(described_class.find("asd")).to be_nil }
      end

      context "find with unexisted id" do
        it { expect(described_class.find(1234)).to be_nil }
      end
    end

    describe ".where" do
      context "with 1 existed parameter" do
        it do 
          response = described_class.where('createdate lt "2014-10-10"') 
          expect(response).to be_an_instance_of(Array) 
          expect(response.first).to be_an_instance_of(described_class)
        end
      end

      context "with 2 existed parameters" do
        it do 
          options = '(createdate lt "2014-07-08")and(createdate gt "1991-01-01")'
          response = described_class.where(options) 
          expect(response).to be_an_instance_of(Array) 
          expect(response.first).to be_an_instance_of(described_class)
        end
      end

      context "with 1 unexisted parameter" do
        it do 
          response = described_class.where('asdsd lt "1286"') 
          expect(response).to be_an_instance_of(NilClass) 
        end
      end

      context "with 1 existed and 1 unexisted parameters" do
        it do
          conditions = '(asdsd lt 1286)and(createdate lt "2013-10-10")'
          response = described_class.where(conditions) 
          expect(response).to be_an_instance_of(NilClass) 
        end
      end
    end

  end

end
