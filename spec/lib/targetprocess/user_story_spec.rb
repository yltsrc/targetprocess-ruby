require 'spec_helper.rb'

describe Targetprocess::UserStory do
  before do
    Targetprocess.configure do |config|
      config.domain = 'http://kamrad.tpondemand.com/api/v1/'
      config.username = 'admin'
      config.password = 'admin'
    end
  end

  describe '.new' do
    it 'creates an instance of UserStory' do
      us = Targetprocess::UserStory.new

      expect(us).to be_an_instance_of(Targetprocess::UserStory)
    end

    context 'can parse' do
      Targetprocess::UserStory::INT_VARS.each do |var|
        context var.camelize do
          it 'from string' do
            us = Targetprocess::UserStory.new({var.camelize => "160"})

            expect(us.send(var.intern)).to eql(160)
          end

          it 'from integer' do
            us = Targetprocess::UserStory.new({var => 16})

            expect(us.send(var.intern)).to eql(16)
          end

          it 'from nil' do
            us = Targetprocess::UserStory.new({var.intern => nil})

            expect(us.send(var.intern)).to be_nil
          end
        end
      end

      Targetprocess::UserStory::FLOAT_VARS.each do |var|
        context var.camelize do
          it 'from string' do
            us = Targetprocess::UserStory.new({var.camelize => "14.500"})

            expect(us.send(var.intern)).to eql(14.5)
          end

          it 'from float' do
            us = Targetprocess::UserStory.new({var => 13.5})

            expect(us.send(var.intern)).to eql(13.5)
          end

          it 'from nil' do
            us = Targetprocess::UserStory.new({var.intern => nil})

            expect(us.send(var.intern)).to be_nil
          end
        end
      end

      Targetprocess::UserStory::CHAR_VARS.each do |var|
        context var.camelize do
          it 'from string' do
            us = Targetprocess::UserStory.new({var.camelize => "Advanced REST API"})

            expect(us.send(var.intern)).to eql("Advanced REST API")
          end

          it 'from nil' do
            us = Targetprocess::UserStory.new({var.intern => nil})

            expect(us.send(var.intern)).to be_nil
          end
        end
      end

      Targetprocess::UserStory::DATE_VARS.each do |var|
        context var.camelize do
          it 'from string' do
            us = Targetprocess::UserStory.new({var.camelize => "2013-06-04T11:00:00"})

            expect(us.send(var.intern)).to eql(DateTime.parse("2013-06-04T11:00:00"))
          end

          it 'from nil' do
            us = Targetprocess::UserStory.new({var.intern => nil})

            expect(us.send(var.intern)).to be_nil
          end
        end
      end

      {
        "EntityType"=>{"Id"=>"4", "Name"=>"UserStory"},
        "Owner"=>{"Id"=>"2", "FirstName"=>"Target", "LastName"=>"Process"},
        "Project"=>{"Id"=>"2", "Name"=>"Tau Product - Kanban #1"},
        "Release"=>{"Id"=>"4", "Name"=>"Release #1"},
        "Priority"=>{"Id"=>"3", "Name"=>"Good"},
        "EntityState"=>{"Id"=>"24", "Name"=>"Done"}
      }.each do |var, hash|
        context var.camelize do
          it 'from string' do
            us = Targetprocess::UserStory.new({var.camelize => hash.to_s})

            expect(us.send(var.intern)).to eql(hash)
          end

          it 'from hash' do
            us = Targetprocess::UserStory.new({var => hash})

            expect(us.send(var.intern)).to eql(hash)
          end

          it 'from nil' do
            us = Targetprocess::UserStory.new({var.intern => nil})

            expect(us.send(var.intern)).to be_nil
          end
        end
      end

      context 'Tags' do
        it 'from string' do
          us = Targetprocess::UserStory.new({"Tags" => "rails, ruby, coffee"})

          expect(us.send(:tags)).to eql(['rails', 'ruby', 'coffee'])
        end

        it 'from array' do
          us = Targetprocess::UserStory.new({"tags" => ['rails', 'ruby']})

          expect(us.send(:tags)).to eql(['rails', 'ruby'])
        end

        it 'from nil' do
          us = Targetprocess::UserStory.new({:tags => nil})

          expect(us.send(:tags)).to eql([])
        end
      end
    end
  end

  describe '.all', :vcr => true do
    it 'returns all user stories' do
      result = Targetprocess::UserStory.all

      expect(result).to be_an_instance_of(Array)
      result.each do |us|
        expect(us).to be_an_instance_of(Targetprocess::UserStory)
      end
    end

    it 'returns all user stories with conditions' do
      result = Targetprocess::UserStory.all(take: 1)

      expect(result).to be_an_instance_of(Array)
      expect(result.length).to eql(1)
    end
  end

  describe '.find', :vcr => true do
    it 'returns requested user story' do
      us = Targetprocess::UserStory.find(160)

      expect(us).to be_an_instance_of(Targetprocess::UserStory)
      expect(us.id).to eql(160)
    end
  end
end
