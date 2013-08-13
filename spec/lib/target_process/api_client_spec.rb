require 'spec_helper'

describe TargetProcess::APIClient, :vcr => true do

  before do
    TargetProcess.configure do |config|
      config.api_url = 'http://tpruby.tpondemand.com/api/v1'
      config.username = 'admin'
      config.password = 'admin'
    end
  end

  subject { TargetProcess.client }

  describe '#get' do
    context "with path like 'entity/id'"do
      it "returns hash of entity's attributes"  do
        et = {id:5, name: "Task", is_extendable: true, is_searchable: true}

        expect(subject.get("entitytypes/5")).to eql(et)
      end
    end

    context "with path like 'entity/'"do
      it "it returns array of entities's attributes hashes " do
        items = [{id:5, name: "Task", is_extendable: true, is_searchable: true},
                 {id:6, name: "User", is_extendable: false, is_searchable: false}]
        response = subject.get("entitytypes", {orderby: "id", take: 2, skip: 4})

        expect(response[:items]).to eql(items)
      end
    end    

    context "with unexisted path "do
      it 'it raises UnexpectedError' do
        expect{
          subject.get("foobars/")
        }.to raise_error(TargetProcess::APIError)
      end
    end    

    context "with unexisted id "do
      it 'it raises NotFound error' do
        expect{
          subject.get("tasks/123123")
        }.to raise_error(TargetProcess::APIError::NotFound)
      end
    end
  end

  describe '#post' do
    context "with correct path and options" do
      it "returns hash of entities's attributes" do
        response = subject.post("projects", {:Name => "foobar#{rand(9999999)}"})

        expect(response[:name]).to match(/foobar/)
        [:id, :name, :description, :start_date, :end_date, :create_date, 
        :modify_date, :last_comment_date, :tags, :numeric_priority, :is_active, 
        :is_product, :abbreviation, :mail_reply_address, :color, :entity_type, 
        :owner, :project, :program, :process, :company, :custom_fields
        ].each do |at|
          expect(response).to have_key(at)
        end
        subject.delete("projects/#{response[:id]}")
      end
    end

    context "with incorrect path and options" do
      it "raises UnexpectedError" do
        expect{
          subject.post("foo/", {foo: "Bar"})
        }.to raise_error(TargetProcess::APIError)
      end
    end
  end

  describe '#delete' do
    context "with url to existed entity" do
      it 'respond with 200 code' do
        project = TargetProcess::Project.new(name: "Foo-#{rand(99999999)}").save
        expect(subject.delete("projects/#{project.id}").code).to eq('200')
      end
    end

    context "with unexisted id in path" do
      it 'raise NotFound error' do
        expect{
          subject.delete('projects/123')
        }.to raise_error(TargetProcess::APIError::NotFound)
      end
    end
  end
end


