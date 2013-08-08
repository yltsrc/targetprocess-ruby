require 'spec_helper'

describe Targetprocess::Base, vcr: true do
  before :all do
    Targetprocess.configure do |config|
      config.api_url = 'http://kamrad.tpondemand.com/api/v1'
      config.username = 'admin'
      config.password = 'admin'
    end
  end

  subject {Targetprocess::Project}

  describe '.new' do
    it "creates an instance of Project" do
      item = subject.new

      expect(item).to be_an_instance_of(subject)
    end

    it "merges recieved hash to @changed_attributes" do
      hash = {name: "foo", description: "bar"}
      item = subject.new(hash)

      expect(item.changed_attributes).to eq(hash) 
    end
  end

  describe '.find' do
    let :project do
      Targetprocess::Project.new(name: "Project#{rand(99999)*rand(99999)}").save
    end
  
    context "with passed correct id" do
      it "returns project" do
        item = subject.find(project.id) 

        expect(item).to be_an_instance_of(subject)
        expect(item.id).to eql(project.id)
      end 
    end

    context "with passed correct id and options" do
      it "returns formatted requested entity" do
        options = {include: "[Tasks]", append: "[Tasks-Count]"}
        item = subject.find(project.id, options) 
        attributes = {:id=>project.id, :tasks_count=>0, :tasks=>{:items=>[]}}

        expect(item).to be_an_instance_of(subject)
        expect(item.attributes).to eq(attributes)
      end
    end

    context "with passed string" do
      it "raise Targetprocess::BadRequest error" do
        expect{
          subject.find("asd")
        }.to raise_error(Targetprocess::APIErrors::BadRequest)
      end
    end

    context "with passed unexisted id" do
      it "raise an Targetprocess::NotFound error" do                     
        expect {
          subject.find(123412)
        }.to raise_error(Targetprocess::APIErrors::NotFound) 
      end
    end
  end
  
  describe '.all' do
    context "without options" do
      it "returns array of projects" do
        result = subject.all

        expect(result).to have(25).projects
        result.each { |item| expect(item).to be_an_instance_of(subject) }
      end
    end

    context "with options" do
      it "returns all subject with conditions " do
        result = subject.all(take: 1, skip: 1)
       
        expect(result).to have(1).project
        expect(result.first).to be_an_instance_of(subject)
      end
    end
  end


  describe ".where" do
    context "with correct condition" do
      it "return array of subjects" do 
        response = subject.where('CreateDate lt "2014-10-10"') 
        
        expect(response).to have(25).projects 
        response.each { |item| expect(item).to be_an_instance_of(subject) }
      end      
    end

    context "with search condition and options" do
      it "return array of subject with conditions" do 
        search = 'CreateDate lt "2014-10-10"'
        response = subject.where(search, OrderByDesc: 'id', Take: 1) 
        
        expect(response).to have(1).project
        expect(response.first).to be_an_instance_of(subject)
      end
    end

    context "with random string without search condition" do
      it "raise an Targetprocess::BadRequest" do 
        expect {
          subject.where('asdad asd asda ')
        }.to raise_error(Targetprocess::APIErrors::BadRequest) 
      end
    end
  end

  describe ".meta" do
    it "returns task's metadata" do 
      response = subject.meta
      uri = "http://kamrad.tpondemand.com/api/v1/Projects"

      expect(response[:name]).to eq("Project")
      expect(response[:uri]).to match(uri)
    end
  end

  describe "#method_missing" do
    let :project do
      Targetprocess::Project.new(name: "Project#{rand(99999)*rand(99999)}").save
    end

    it "provide getters for attributes's values" do
      project.attributes.keys.each do |key|
        expect(project.send(key)).to eq(project.attributes[key])
      end
    end      

    it "provides any setters" do
      project = subject.new
      project.name, project.description, project.asd = "foo", "bar", "asd"
      
      expect(project.name).to eq("foo")
      expect(project.description).to eq("bar")
      expect(project.asd).to eq("asd")
    end

    it "not allow to edit id" do
      task = subject.new(name: "Foo", description: "Bar")
      task.id = 123
      
      expect(task.id).to eq(nil)        
      expect(task.changed_attributes[:id]).to eq(nil)        
    end 

    context "if set any attribute" do
      it "add it to changed_attributes" do
        new_name = "new name"
        project.name = new_name

        expect(project.changed_attributes[:name]).to eq(new_name)
      end
    end

    context "if edit attribute with the same old value in attributes" do
      it "delete attribute from changed_attributes" do
        prev_name = project.name
        project.name = "foobar"
        project.name = prev_name

        expect(project.changed_attributes[:name]).to be_nil
        expect(project.attributes[:name]).to eq(prev_name)
      end   
    end
  end

  describe "#delete" do
    let :project do
      Targetprocess::Project.new(name: "Project#{rand(99999)*rand(99999)}").save
    end

    context "if project exist on remote host" do
      it "delete project on remote host and return true" do

        expect(project.delete).to eq(true)
        expect{
          subject.find(project.id) 
        }.to raise_error(Targetprocess::APIErrors::NotFound)
      end
    end

    # context "if project doesn't exit on remote host" do
    #   it "raise NotFound error" do
    #     pro = project
    #     pro.delete
    #     expect{
    #       subject.find(pro.id)
    #     }.to raise_error(Targetprocess::APIErrors::NotFound)
    #   end
    # end
  end

  describe "#save" do
    context "called on project with required fields" do
      it "save it on remote host and update local instance's attributes" do
        project = subject.new(name: "Project#{rand(99999)*rand(99999)}").save
        attrs = subject.find(project.id).attributes.delete(:numeric_priority)
        expect(attrs).to eq(project.attributes.delete(:numeric_priority))
      end
    end

    context "called on project with updated attributes" do
      it "updates task on remote host and clean changed attributes" do
        project = subject.all(orderbydesc: "id", take: 1).first
        project.name = "Project#{rand(99999)*rand(99999)}"
        project.save 

        expect(subject.find(project.id)).to eq(project)
      end
    end

    context "called on up-to-date local project" do
      it "do nothing with local instance" do
        project = subject.all(orderbydesc: "id", take: 1).first
        project.save 

        expect(subject.find(project.id)).to eq(project)
      end
    end
  end
    
  describe "#eq" do
    it "compares changed attributes" do
      task1 = subject.new(:name => 'first')
      task2 = subject.new(:name => 'second')
      task1.name = 'second'

      expect(task1).to eq(task2)
    end

    it "compares attributes with changed_attributes" do
      task1 = subject.new
      task1.instance_variable_set(:@attributes, name: "name1")
      task2 = subject.new
      task2.instance_variable_set(:@attributes, name: "name2")
      task2.name = "name1"

      expect(task2).to eq(task1)
    end

    it "compares task with integer" do
      task = subject.new(name: "New task")
     
      expect(task).to_not eq(3)
    end

    it "comapres tasks with different attributes" do
      task1 = subject.new(name: "New task")
      task2 = subject.all(orderByDesc: "id", Take: 1).first 

      expect(task1).to_not eq(task2)
      expect(task2).to_not eq(task1)
    end
  end

  describe "temporary hack to prevent filling test account with garbage" do
    it "is temporary, never mind and pass by" do
      projects = subject.all(orderbydesc: "id", take: 7)
        projects.each { |p| p.delete }
      expect(true).to eq(true)
    end
  end
end
