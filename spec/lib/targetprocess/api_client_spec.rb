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
    it 'returns response body' do
      expect(subject.get('?')).to == 'response'
    end
  end

  describe '#post' do
    it 'returns response body' do
      expect(subject.post('?')).to == 'response'
    end
  end

  describe '#delete' do
    it 'returns response body' do
      expect(subject.delete('?')).to == 'response'
    end
  end

end
