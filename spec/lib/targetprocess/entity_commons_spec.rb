require 'spec_helper'

  describe Targetprocess::EntityCommons, vcr: true do
    before do
      Targetprocess.configure do |config|
        config.domain = 'http://kamrad.tpondemand.com/api/v1'
        config.username = 'admin'
        config.password = 'admin'
      end

    end

    describe '.new' do
      it "creates an instance of Targetprocess::Task" do
        item = Targetprocess::Task.new

        expect(item).to be_an_instance_of(Targetprocess::Task)
      end
    end

    describe '.all' do
      it "returns all Targetprocess::Task" do
        result = Targetprocess::Task.all

        expect(result).to be_an_instance_of(Array)
        result.each do |item|
          expect(item).to be_an_instance_of(Targetprocess::Task)
        end
      end

      it "returns all Targetprocess::Task with conditions " do
        result = Targetprocess::Task.all(take: 1)
       
        expect(result).to be_an_instance_of(Array)
        expect(result.first).to be_an_instance_of(Targetprocess::Task)
      end
    end

    describe '.find' do
      it "returns requested Targetprocess::Task " do
        item = Targetprocess::Task.find(185) 

        expect(item).to be_an_instance_of(Targetprocess::Task)
        expect(item.id).to eql(185)
      end      

      it "returns requested Targetprocess::Task " do
        item = Targetprocess::Task.find(185) 

        expect(item).to be_an_instance_of(Targetprocess::Task)
        expect(item.id).to eql(185)
      end

      it "raise Targetprocess::BadRequest error" do
        expect{
          Targetprocess::Task.find("asd")
        }.to raise_error(Targetprocess::BadRequest)
      end

      it "raise an Targetprocess::NotFound error" do                     
        expect {
          Targetprocess::Task.find(1234)
        }.to raise_error(Targetprocess::NotFound) 
      end

    end

    describe ".where" do
      it "return array of Targetprocess::Task" do 
        response = Targetprocess::Task.where('createdate lt "2014-10-10"') 
        
        expect(response).to be_an_instance_of(Array) 
        expect(response.first).to be_an_instance_of(Targetprocess::Task)
      end

      it "return array of #{Targetprocess::Task}" do 
        options = '(createdate lt "2014-07-08")and(createdate gt "1991-01-01")'
        response = Targetprocess::Task.where(options) 

        expect(response).to be_an_instance_of(Array) 
        expect(response.first).to be_an_instance_of(Targetprocess::Task)
      end

      it "raise an Targetprocess::BadRequest" do 
        expect {
          Targetprocess::Task.where('asdsd lt 1286')
        }.to raise_error(Targetprocess::BadRequest) 
      end

      it "raise an Targetprocess::BadRequest " do
        conditions = '(asdsd lt 1286)and(createdate lt "2013-10-10")'
        expect {
          Targetprocess::Task.where(conditions)
        }.to raise_error(Targetprocess::BadRequest) 
      end
    end

    # describe "#save" do
    #   it "create #{Targetprocess::Task} on remote host " do
    #     item = Targetprocess::Task.new
    #     {name: "Test #{Targetprocess::Task}-#{Time.now.to_i}", description: "something",
    #      project: {id: 221}, owner:{id: 2}, 
    #      enddate: Time.now, general: {id:182},
    #      startdate: Time.now+10 ,
    #      enddate: Time.new(2013,12,28,8,0,0,"+03:00"),
    #      release:{id: 282}, userstory: {id: 234},
    #      steps: "check", success: "ok", 
    #      email: "test#{Time.now.to_i}@gmail.com",
    #      login: "user-#{Time.now.to_i}", password: "secretsecret",
    #      entitytype: {id: 12}, testplan: {id: 57},
    #      testplanrun: {id: 217}, assignable: {id: 143},
    #      generaluser: {id: 1}, role: {id: 1}, user: {id: 1},
    #      testcase:{id: 467}
    #      }.each do |k,v|
    #        if Targetprocess::Task.attributes["writable"].include?(k.to_s) && !(Targetprocess::Task.to_s.demodulize.downcase == k.to_s )
    #           item.send(k.to_s+"=", v) 
    #        end
    #      end
    #      p item
    #     expect(item.save).to be_an_instance_of(Targetprocess::Task)
    #   end
    # end

    # describe "#delete" do
    #   it "delete #{Targetprocess::Task} with the greatest id" do
    #     item = Targetprocess::Task.all(orderbydesc: "id").first
    #     p item.id
    #     item.delete
    #     expect{
    #       Targetprocess::Task.find(item.id) 
    #     }.to raise_error(Targetprocess::NotFound)
    #   end
    # end

  end

