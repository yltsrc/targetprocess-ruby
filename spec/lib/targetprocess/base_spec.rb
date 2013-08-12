require 'spec_helper'

describe Targetprocess::Base, vcr: true do
  before :all do
    Targetprocess.configure do |config|
      config.api_url = 'http://tpruby.tpondemand.com/api/v1/'
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
    context "with passed correct id" do
      it "returns project" do
        project = Targetprocess::Project.new(
                  name: "Project#{rand(99999)*rand(99999)}",
                  start_date: Time.now).save
        item = subject.find(project.id) 

        expect(item).to be_an_instance_of(subject)
        expect(item.id).to eql(project.id)
        project.delete
      end 
    end

    context "with passed correct id and options" do
      it "returns formatted requested entity" do
        project = Targetprocess::Project.new(
                  name: "Project#{rand(99999)*rand(99999)}",
                  start_date: Time.now).save
        options = {include: "[Tasks]", append: "[Tasks-Count]"}
        item = subject.find(project.id, options) 
        attributes = {:id=>project.id, :tasks_count=>0, :tasks=>{:items=>[]}}

        expect(item).to be_an_instance_of(subject)
        expect(item.attributes).to eq(attributes)
         project.delete
      end
    end

    context "with passed string" do
      it "raise Targetprocess::BadRequest error" do
        expect{
          subject.find("asd")
        }.to raise_error(Targetprocess::APIError::BadRequest)
      end
    end

    context "with passed unexisted id" do
      it "raise an Targetprocess::NotFound error" do                     
        expect {
          subject.find(123412)
        }.to raise_error(Targetprocess::APIError::NotFound) 
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
          subject.where('asdad asd asda')
        }.to raise_error(Targetprocess::APIError::BadRequest) 
      end
    end
  end

  describe ".meta" do
    it "returns project's metadata" do 
      response = subject.meta
      uri = Targetprocess.configuration.api_url + "Projects"

      expect(response[:name]).to eq("Project")
      expect(response[:uri]).to match(uri)
    end
  end

  describe "#method_missing" do
    it "provide getters for attributes's values" do
      unique_name = "Project#{rand(99999)*rand(99999)}"
      project = Targetprocess::Project.new(name: unique_name).save
      
      project.attributes.keys.each do |key|
        expect(project.send(key)).to eq(project.attributes[key])
      end
      project.delete
    end      

    it "provides any setters" do
      project = subject.new
      project.name, project.description, project.asd = "foo", "bar", "asd"
      
      expect(project.name).to eq("foo")
      expect(project.description).to eq("bar")
      expect(project.asd).to eq("asd")
    end

    it "not allow to edit id" do
      project = subject.new(name: "Foo", description: "Bar")
      
      expect{
        project.id = 123
      }.to raise_error(NoMethodError)        
    end 

    context "if set any attribute" do
      it "add it to changed_attributes" do
        unique_name = "Project#{rand(99999)*rand(99999)}"
        project = Targetprocess::Project.new(name: unique_name).save
        new_name = "new name"
        project.name = new_name

        expect(project.changed_attributes[:name]).to eq(new_name)
        project.delete
      end
    end

    context "if edit attribute with the same old value in attributes" do
      it "delete attribute from changed_attributes" do
        unique_name = "Project#{rand(99999)*rand(99999)}"
        project = Targetprocess::Project.new(name: unique_name).save
        prev_name = project.name
        project.name = "foobar"
        project.name = prev_name

        expect(project.changed_attributes[:name]).to be_nil
        expect(project.attributes[:name]).to eq(prev_name)
        project.delete
      end   
    end
  end

  describe "#delete" do
    context "if project exist on remote host" do
      it "delete project on remote host and return true" do
        unique_name = "Project#{rand(99999)*rand(99999)}"
        project = Targetprocess::Project.new(name: unique_name).save
        
        expect(project.delete).to eq(true)
        expect{
          subject.find(project.id) 
        }.to raise_error(Targetprocess::APIError::NotFound)
      end
    end
  end

  describe "#save" do
    context "called on project with required fields" do
      it "save it on remote host and update local instance's attributes" do
        project = subject.new(name: "Project#{rand(99999)*rand(99999)}").save
        remote_project = subject.find(project.id)
        project.numeric_priority = nil
        remote_project.numeric_priority = nil

        expect(remote_project).to eq(project)
        project.delete
      end
    end

    context "called on project with updated attributes" do
      it "updates task on remote host and clean changed attributes" do
        project = subject.new(name: "Project#{rand(99999)*rand(99999)}").save
        project.name = "Project_new_name#{rand(99999)*rand(99999)}"
        project.save 
        remote = subject.find(project.id)
        remote.numeric_priority = nil
        project.numeric_priority = nil 

        expect(remote).to eq(project) 
        project.delete       
      end
    end

    context "called on up-to-date local project" do
      it "do nothing with local instance" do
        project = subject.new(name: "Project#{rand(99999)*rand(99999)}").save
        project.save 
        remote = subject.find(project.id)
        project.numeric_priority = nil
        remote.numeric_priority = nil

        expect(remote).to eq(project)     
        project.delete   
      end
    end
  end
    
  describe "#eq" do
    it "compares changed attributes" do
      project1 = subject.new(:name => 'first')
      project2 = subject.new(:name => 'second')
      project1.name = 'second'

      expect(project1).to eq(project2)
    end

    it "compares attributes with changed_attributes" do
      project1 = subject.new
      project1.instance_variable_set(:@attributes, name: "name1")
      project2 = subject.new
      project2.instance_variable_set(:@attributes, name: "name2")
      project2.name = "name1"

      expect(project2).to eq(project1)
    end

    it "compares project with integer" do
      project = subject.new(name: "New project")
     
      expect(project).to_not eq(3)
    end

    it "comapres projects with different attributes" do
      project1 = subject.new(name: "New project")
      project2 = subject.new(name: "Project#{rand(99999)*rand(99999)}").save

      expect(project1).to_not eq(project2)
      expect(project2).to_not eq(project1)
      project2.delete
    end
  end

  describe '#respond_to?' do
    it "doesn't responds to underscored getter for non existed attribute" do
      expect(subject.new.respond_to?(:underscored_method)).to be_false
    end
    
    it "responds to underscored getter forexisted attribute" do
      expect(subject.new(foo: "bar").respond_to?(:foo)).to be_true
    end

    it "responds to underscored setter" do
      expect(subject.new.respond_to?(:underscored_method=)).to be_true
    end

    it "doesn't responds to camelized getter" do
      expect(subject.new.respond_to?(:camelizedMethod)).to be_false
    end

    it "doesn't responds to camelized setter" do
      expect(subject.new.respond_to?(:camelizedMethod=)).to be_false
    end

    it "doesn't responds to id setter" do
      expect(subject.new.respond_to?(:id=)).to be_false
    end

    it "doesn't responds to bang methods" do
      expect(subject.new.respond_to?(:underscored_method!)).to be_false
    end

    it "doesn't responds to question methods" do
      expect(subject.new.respond_to?(:underscored_method?)).to be_false
    end
  end
end
