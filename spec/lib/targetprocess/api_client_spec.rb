require 'spec_helper'

describe Targetprocess::APIClient, :vcr => true do

  before do
    Targetprocess.configure do |config|
      config.api_url = 'http://kamrad.tpondemand.com/api/v1'
      config.username = 'admin'
      config.password = 'admin'
    end
  end

  let(:last_project_id) {Targetprocess::Project.all(orderbydesc: "id").first.id}

  subject { Targetprocess.client }

  describe '#get' do
    it 'returns response hash' do
      et = {id:5, name: "Task", is_extendable: true, is_searchable: true}

      expect(subject.get("entitytypes/5")).to eql(et)
    end

    it 'it returns response array' do
      items = [{id:5, name: "Task", is_extendable: true, is_searchable: true},
               {id:6, name: "User", is_extendable: false, is_searchable: false}]
      response = subject.get("entitytypes", {orderby: "id", take: 2, skip: 4})

      expect(response[:items]).to eql(items)
    end
  end

  describe '#post' do
    it 'returns response hash' do
      response = subject.post("projects", {:Name => "Test-post"})

      expect(response).to include(name: "Test-post" )
      [:id, :name, :description, :start_date, :end_date, :create_date, 
      :modify_date, :last_comment_date, :tags, :numeric_priority, :is_active, 
      :is_product, :abbreviation, :mail_reply_address, :color, :entity_type, 
      :owner, :project, :program, :process, :company, :custom_fields
      ].each do |at|
        expect(response).to have_key(at)
      end
    end
  end

  describe '#delete' do
    it 'returns 200 code' do
      expect(subject.delete("projects/#{last_project_id}").code).to eq('200')
    end

    it 'raise NotFound error' do
      expect{
        subject.delete('projects/123')
      }.to raise_error(Targetprocess::ApiErrors::NotFound)
    end
  end

end


