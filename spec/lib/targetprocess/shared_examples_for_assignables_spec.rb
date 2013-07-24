require 'spec_helper'

shared_examples "an assignable" do
  let(:id) { described_class.find(:all).first.id}

  describe described_class do
    before do
      Targetprocess.configure do |config|
        config.domain = 'http://kamrad.tpondemand.com/api/v1'
        config.username = 'admin'
        config.password = 'admin'
      end
    end

    describe '.new' do
      it "creates an instance of #{described_class}" do
        item = described_class.new

        expect(item).to be_an_instance_of(described_class)
      end

      it 'can parse json date' do
        item = described_class.new({:createdate => "\/Date(1374506427000-0500)\/"})
        real_time = Time.new(2013,07,22,18,20,27,"+03:00")

        expect(item.createdate).to eq(real_time) 
      end      

      it 'can normalize hash value' do
        item = described_class.new({:project => {"Id"=>1, "Name" => "boss"}})
        normalized_hash = {id:1, name: "boss"}
        real_hash = item.instance_variable_get(:@project)

        expect(real_hash).to eq(normalized_hash)
      end
    end

    describe '.all', :vcr => true do
      it 'returns all #{described_class}' do
        result = described_class.all

        expect(result).to be_an_instance_of(Array)
        result.each do |item|
          expect(item).to be_an_instance_of(described_class)
        end
      end

      it 'returns all #{described_class} with conditions' do
        result = described_class.all(take: 1)
        expect(result).to be_an_instance_of(Array)
        expect(result.length).to eql(1)
      end
    end

    describe '.find', :vcr => true do
      it "returns requested #{described_class}" do
        item = described_class.find(id)

        expect(item).to be_an_instance_of(described_class)
        expect(item.id).to eql(id)
      end

      it "return 1 #{described_class}" do
        expect(described_class.all(take: 1).count).to eq(1)
      end

      it "raise Targetprocess::BadRequest error" do
        expect{
          described_class.find("asd")
        }.to raise_error(Targetprocess::BadRequest)
      end

      it "raise an Targetprocess::NotFound error" do                     
        expect {
          described_class.find(1234)
        }.to raise_error(Targetprocess::NotFound) 
      end

    end

    describe ".where" do
      it "return array of #{described_class}" do 
        response = described_class.where('createdate lt "2014-10-10"') 
        expect(response).to be_an_instance_of(Array) 
        expect(response.first).to be_an_instance_of(described_class)
      end

      it "return array of #{described_class}" do 
        options = '(createdate lt "2014-07-08")and(createdate gt "1991-01-01")'
        response = described_class.where(options) 

        expect(response).to be_an_instance_of(Array) 
        expect(response.first).to be_an_instance_of(described_class)
      end

      it "raise an Targetprocess::BadRequest" do 
        expect {
          described_class.where('asdsd lt 1286')
        }.to raise_error(Targetprocess::BadRequest) 
      end

      it "raise an Targetprocess::BadRequest " do
        conditions = '(asdsd lt 1286)and(createdate lt "2013-10-10")'
        expect {
          described_class.where(conditions)
        }.to raise_error(Targetprocess::BadRequest) 
      end
    end

    describe ".save" do
      it "create #{described_class} new instance to remote host " do
        item = described_class.new
        {name: "Test #{described_class}-#{Time.now.to_i}", description: "something",
         project: {id: 221}, owner:{id: 2}, 
         enddate: Time.now, general: {id:182},
         startdate: Time.new(2013,12,25,8,0,0,"+03:00"),
         enddate: Time.new(2013,12,26,8,0,0,"+03:00"),
         release:{id: 282}, userstory: {id: 234},
         steps: "check", success: "ok", 
         email: "test#{Time.now.to_i}@gmail.com",
         login: "user-#{Time.now.to_i}", password: "secretsecret"
         }.each do |k,v|
          item.send(k.to_s+"=", v) if item.respond_to?(k) && !described_class.to_s.downcase.match(k.to_s) 
        end
        expect(item.save).to be_an_instance_of(described_class)
      end
    end

  end
end     


