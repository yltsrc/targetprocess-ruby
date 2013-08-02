require 'spec_helper'

describe Targetprocess::APIClient, :vcr => true do

  before do
    Targetprocess.configure do |config|
      config.domain = 'http://kamrad.tpondemand.com/api/v1'
      config.username = 'admin'
      config.password = 'admin'
    end
  end

  subject { Targetprocess.client }

  describe '#get' do
    it 'returns response hash' do
      et = {id:5, name: "Task", isextendable: true, issearchable: true}

      expect(subject.get("entitytypes/5")).to eql(et)
    end

    it 'it returns response array' do
      ets_items = [{id:5, name: "Task", isextendable: true, issearchable: true},
             {id:6, name: "User", isextendable: false, issearchable: false}]
      response = subject.get("entitytypes", {orderby: "id", take: 2, skip: 4})

      expect(response[:items]).to eql(ets_items)
    end
  end

  describe '#post' do
    it 'returns response hash' do
      response = subject.post("projects", {name: "post-test"})

      expect(response).to include(name: "post-test" )
      [:id, :name, :description, :startdate, :enddate, :createdate, 
      :modifydate, :lastcommentdate, :tags, :numericpriority, :isactive, 
      :isproduct, :abbreviation, :mailreplyaddress, :color, :entitytype, 
      :owner, :project, :program, :process, :company, 
      :customfields].each do |at|
        expect(response).to have_key(at)
      end
    end
  end

  describe '#delete' do
    it 'returns code 200' do
      expect(subject.delete('projects/534')).to eq("200")
    end

    it 'raise NotFound error' do
      expect{subject.delete('projects/123')}.to raise_error(Targetprocess::NotFound)
    end
  end

end


