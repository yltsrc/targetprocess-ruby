require 'spec_helper'

describe Targetprocess::UserStoryResource do

	subject(:storyResource) { Targetprocess::UserStoryResource.new('admin','admin','http://kamrad.tpondemand.com') }

	describe "storyResource", :vcr => true do
	  it "must be an instance of UserStoryResource" do 
  		expect(storyResource).to be_an_instance_of(Targetprocess::UserStoryResource)
	  end
	end

	describe "#all_stories", :vcr => true do
		it "should be an array" do		 
			expect(storyResource.all_stories.class).to eq(Array) 
		end

	  it "shoould contain instances of Targetprocess::Userstory " do
	    storyResource.all_stories.each do |obj|
	    	expect(obj.class).to eq(Targetprocess::Userstory)
	    end
	  end	  
	end

	describe "#stories_by_project", :vcr => true do
		it "should be an instance of Array" do
	 		expect(storyResource.stories_by_project("5FA0BB2EB47B24832C250EB73431AB2F").class).to eq(Array) 
	 	end

	  it "shoould contain instances of Targetprocess::Userstory" do
	 		storyResource.stories_by_project("5FA0BB2EB47B24832C250EB73431AB2F").each do |obj|
	 			expect(obj.class).to eq(Targetprocess::Userstory) 
			end
	 	end	  
	end	

	describe "#bugs_by_project", :vcr => true do
		it "should be an instance of HTTParty::Response" do
	 		expect(storyResource.bugs_by_project("5FA0BB2EB47B24832C250EB73431AB2F").class).to eq(HTTParty::Response) 
	 	end

	  it "shoould have respond with 200 " do
	 		expect(storyResource.bugs_by_project("5FA0BB2EB47B24832C250EB73431AB2F").header.code).to eq("200") 
	 	end	  

	  it "should contain Bugs" do
			expect(storyResource.bugs_by_project("5FA0BB2EB47B24832C250EB73431AB2F").parsed_response["Bugs"]).not_to be_nil 
		end
	end

	describe "#story_by_ids", :vcr => true do
		it "should be similar to Userstory instance" do
 				response = storyResource.story_by_ids(182)
				story = Targetprocess::Userstory.new(:id=>182, :name=>"Edit Area 1", :description=>nil, :createdate=>"2013-06-18T09:20:00", :modifydate=>"2013-07-08T02:44:50", :startdate=>nil, :enddate=>nil, :lastcommentdate=>"2013-07-08T02:36:54", :lastcommenteduser_firstname => "Administrator", :lastcommenteduser_id=>1, :lastcommenteduser_lastname=>"Administrator", :tags=> "asd, qwe", :numericpriority=>59.5, :effort=>8.0, :effortcompleted=>0.0, :efforttodo=>8.0, :timespent=>0.0, :timeremain=>8.0, :initialestimate=>8.0, :entitytype_id=>4, :entitytype_name=>"UserStory", :owner_id=>7, :owner_firstname=>"Jack", :owner_lastname=>"Blue", :project_id=>2, :project_name=>"Tau Product - Kanban #1", :release_id=>6, :release_name=>"Release #2", :iteration=>nil, :teamiteration=>nil, :team=>nil, :priority_id=>2, :priority_name=>"Great", :entitystate_id=>40, :entitystate_name=>"Planned", :feature=>nil, :customfields=>nil)
				expect(response).to eq story
	 	end
	end	

	describe "#story_tasks", :vcr => true do
		it "should be an instance of HTTParty::Response" do
	 		expect(storyResource.story_tasks(183).class).to eq(HTTParty::Response) 
	 	end

	  it "shoould have respond with 200 " do
	 		expect(storyResource.story_tasks(183).header.code).to eq("200") 
	 	end	  

	  it "should contain Tasks" do
			expect(storyResource.story_tasks(183).parsed_response["Tasks"]).not_to be_nil 
		end
	end

end




