require 'spec_helper'

shared_examples "an assignable" do
  let(:id) { described_class.find(:all).first.id}

  describe described_class do
    before do
      Targetprocess.configure do |config|
        config.domain = 'http://kamrad.tpondemand.com/api/v1/'
        config.username = 'admin'
        config.password = 'admin'
      end
    end

    describe '.new' do
      it 'creates an instance of UserStory' do
        us = described_class.new

        expect(us).to be_an_instance_of(described_class)
      end

      context 'can parse' do
        all = (described_class.missings + described_class::ALL_VARS).collect{|v| v.to_s}
        (described_class::INT_VARS&all).each do |var|
          context var do
            it 'from string' do
              us = described_class.new({var => "160"})

              expect(us.send(var.intern)).to eq(160)
            end

            it 'from integer' do
              us = described_class.new({var => 20})

              expect(us.send(var.intern)).to eql(20)
            end

            it 'from nil' do
              us = described_class.new({var.intern => nil})

              expect(us.send(var.intern)).to be_nil
            end
          end
        end

        (described_class::FLOAT_VARS&all).each do |var|
          context var do
            it 'from string' do
              us = described_class.new({var => "14.500"})

              expect(us.send(var.intern)).to eql(14.5)
            end

            it 'from float' do
              us = described_class.new({var => 13.5})

              expect(us.send(var.intern)).to eql(13.5)
            end

            it 'from nil' do
              us = described_class.new({var.intern => nil})

              expect(us.send(var.intern)).to be_nil
            end
          end
        end

        (described_class::DATE_VARS&all).each do |var|
          context var do
            it 'from string' do
              us = described_class.new({var => "2013-06-04T11:00:00"})

              expect(us.send(var.intern)).to eql(DateTime.parse("2013-06-04T11:00:00"))
            end

            it 'from nil' do
              us = described_class.new({var.intern => nil})

              expect(us.send(var.intern)).to be_nil
            end
          end
        end

        {
          "EntityType"=>{:id => 4, :name => "UserStory"},
          "Owner"=>{:id => 2, :firstname => "Target", :lastname => "Process"},
          "Project"=>{:id => 2, :name => "Tau Product - Kanban #1"},
          "Release"=>{:id => 4, :name => "Release #1"},
          "Priority"=>{:id => 3, :name => "Good"},
          "EntityState"=>{:id => 24, :name => "Done"}
        }.each do |var, hash|
          context var do
            it 'from hash' do
              us = described_class.new({var => hash})

              expect(us.send(var.downcase.intern)).to eql(hash)
            end

            it 'from nil' do
              us = described_class.new({var.intern => nil})

              expect(us.send(var.downcase.intern)).to be_nil
            end
          end
        end

        unless (described_class::ARR_VARS&all).empty?
          context 'Tags' do
            it 'from string' do
              us = described_class.new({"Tags" => "rails, ruby, coffee"})
              expect(us.send(:tags)).to eql(['rails', 'ruby', 'coffee'])
            end

            it 'from array' do
              us = described_class.new({"tags" => ['rails', 'ruby']})

              expect(us.send(:tags)).to eql(['rails', 'ruby'])
            end

            it 'from nil' do
              us = described_class.new({:tags => nil})

              expect(us.send(:tags)).to eql(nil)
            end
          end
        end
      end
    end

    describe '.all', :vcr => true do
      it 'returns all #{described_class}' do
        result = described_class.all

        expect(result).to be_an_instance_of(Array)
        result.each do |us|
          expect(us).to be_an_instance_of(described_class)
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
        us = described_class.find(id)

        expect(us).to be_an_instance_of(described_class)
        expect(us.id).to eql(id)
      end

      context "return all with parameters" do
        it { expect(described_class.find(:all, {take: 1}).count).to eq(1)}
      end

      context "find with literal id" do
        it do 
          expect{
            described_class.find("asd")
          }.to raise_error(Targetprocess::BadRequest)
        end
      end

      context "find with unexisted id" do                     
        it do 
          expect {
            described_class.find(1234)
          }.to raise_error(Targetprocess::NotFound) 
        end
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
          expect {
            described_class.where('asdsd lt 1286')
          }.to raise_error(Targetprocess::BadRequest) 
        end
      end

      context "with 1 existed and 1 unexisted parameters" do
        it do
          conditions = '(asdsd lt 1286)and(createdate lt "2013-10-10")'
          expect {
            described_class.where(conditions)
          }.to raise_error(Targetprocess::BadRequest) 
        end
      end
    end

  end
end     


