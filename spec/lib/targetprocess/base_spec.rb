require 'spec_helper'

  describe Targetprocess::Base, vcr: true do
    before do
      Targetprocess.configure do |config|
        config.api_url = 'http://kamrad.tpondemand.com/api/v1'
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

    describe "#method_missing" do
      it "check for getters existance" do
        task = Targetprocess::Task.all(orderByDesc: "Id", take: 1).first

        task.attributes.keys.each do |key|
          expect(task.send(key)).to eq(task.attributes[key])
        end
      end      

      it "check for setters existance" do
        task = Targetprocess::Task.new
        task.name = "foo"
        task.description = "bar"
        
        expect(task.name).to eq("foo")
        expect(task.description).to eq("bar")
      end

      it "delete changed_attribute if exists equal one in attributes" do
        task = Targetprocess::Task.all(orderByDesc: "Id", take: 1).first
        prev_name = task.name
        task.name = "foobar"
        task.name = prev_name
        
        expect(task.changed_attributes[:name]).to be_nil
        expect(task.attributes[:name]).to eq(prev_name)
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
        result = Targetprocess::Task.all(Take: 1)
       
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
        }.to raise_error(Targetprocess::ApiErrors::BadRequest)
      end

      it "raise an Targetprocess::NotFound error" do                     
        expect {
          Targetprocess::Task.find(1234)
        }.to raise_error(Targetprocess::ApiErrors::NotFound) 
      end

    end

    describe ".where" do
      it "return array of Targetprocess::Task" do 
        response = Targetprocess::Task.where('CreateDate lt "2014-10-10"') 
        
        expect(response).to be_an_instance_of(Array) 
        expect(response.first).to be_an_instance_of(Targetprocess::Task)
      end      
      it "return array of Targetprocess::Task with conditions" do 
        search = 'CreateDate lt "2014-10-10"'
        response = Targetprocess::Task.where(search, OrderByDesc: 'id', Take: 1) 
        
        expect(response).to have(1).task
        expect(response.first).to be_an_instance_of(Targetprocess::Task)
      end

      it "return array of Targetprocess::Task" do 
        options = '(CreateDate lt "2014-07-08")and(CreateDate gt "1991-01-01")'
        response = Targetprocess::Task.where(options) 

        expect(response).to be_an_instance_of(Array) 
        expect(response.first).to be_an_instance_of(Targetprocess::Task)
      end

      it "raise an Targetprocess::BadRequest" do 
        expect {
          Targetprocess::Task.where('asdsd lt 1286')
        }.to raise_error(Targetprocess::ApiErrors::BadRequest) 
      end

      it "raise an Targetprocess::BadRequest " do
        conditions = '(asdsd lt 1286)and(createdate lt "2013-10-10")'
        
        expect {
          Targetprocess::Task.where(conditions)
        }.to raise_error(Targetprocess::ApiErrors::BadRequest) 
      end
    end

    describe "#meta" do
      it "returns task's metadata" do 
        response = Targetprocess::Task.meta
        description = "A small chunk of work, typically less than 16 hours. Task must relate to User Story. It is not possible to create Tasks without User Story."

        expect(response[:name]).to eq("Task")
        expect(response[:description]).to match(description)
      end
    end

    describe "#delete" do
      it "delete #{Targetprocess::Task} with the greatest id" do
        item = Targetprocess::Task.all(createondesc: "id", take: 1).first
        resp = item.delete

        expect(resp).to eq(true)
        expect{item.delete}.to raise_error(Targetprocess::ApiErrors::NotFound)
        expect{
          Targetprocess::Task.find(item.id) 
        }.to raise_error(Targetprocess::ApiErrors::NotFound)
      end
    end

    describe "#save" do
      it "create new task and save it on remote host " do
        props = { name: "Task-#{Time.now.to_i}", userstory: {id: 531}, 
                 priority: {id: 11} } 
        item = Targetprocess::Task.new(props)
        item.save 
        id = Targetprocess::Task.all(orderbydesc: 'id', take: 1 ).first.id

        expect(item).to be_an_instance_of(Targetprocess::Task)
        expect(id).to eq(item.id)
      end

      it "updates task on remote host" do
        item = Targetprocess::Task.all(orderbydesc: "id", take: 1).first
        item.name = "new task name"
        item.save 

        expect(Targetprocess::Task.find(item.id)).to eq(item)
      end

      it "update name of remote task" do 
        Targetprocess::Task.new(id: 235, name: "New name").save 

        expect(Targetprocess::Task.find(235).name).to eq("New name")
      end

      it 'should have getter for dirty attributes' do
        task = Targetprocess::Task.new(:name => 'test', :userstory => {id:531})
        expect(task.name).to eq('test')
        task.name = 'old name'
        expect(task.name).to eq('old name')
        task.save
        expect(task.name).to eq('old name')
        task.name = 'new name'
        expect(task.name).to eq('new name')
        task.save
        expect(task.name).to eq('new name')
      end
    end

    describe "#eq" do
      it "compares changed attributes" do
        task1 = Targetprocess::Task.new(:name => 'first')
        task2 = Targetprocess::Task.new(:name => 'second')
        task1.name = 'second'

        expect(task1).to eq(task2)
      end

      it "compares attributes with changed_attributes" do
        task1 = Targetprocess::Task.new
        task1.attributes = {:name => "name1"}
        task2 = Targetprocess::Task.new
        task2.attributes = {:name => "name2"}
        task2.name = "name1"
        
        expect(task2).to eq(task1)
      end

      it "compares task with integer" do
        task = Targetprocess::Task.new(name: "New task")
       
        expect(task).to_not eq(3)
      end

      it "comapres tasks with different attributes" do
        task1 = Targetprocess::Task.new(name: "New task")
        task2 = Targetprocess::Task.all(orderByDesc: "id", Take: 1).first 

        expect(task1).to_not eq(task2)
        expect(task2).to_not eq(task1)
      end
    end

  end
