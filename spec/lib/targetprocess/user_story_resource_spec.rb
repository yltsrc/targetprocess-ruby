require 'spec_helper'

describe Targetprocess::UserStoryResource do

	subject(:storyResource) { Targetprocess::UserStoryResource.new('admin','admin','http://kamrad.tpondemand.com') }

	describe "storyResource", :vcr => true do
	  it "must be an instance of UserStoryResource" do 
  		expect(storyResource).to be_an_instance_of(Targetprocess::UserStoryResource)
	  end
	end

	describe "#all_stories", :vcr => true do
		it "should be an instance of HTTParty::Response" do		 
			expect(storyResource.all_stories.class).to eq(HTTParty::Response) 
		end

	  it "shoould have respond with 200 " do
	    expect(storyResource.all_stories.header.code).to eq("200") 
	  end	  

	  it "should contain UserStories" do
	  	expect(storyResource.all_stories.parsed_response["UserStories"]).not_to be_nil 
	  end
	end

	describe "#stories_by_project", :vcr => true do
		it "should be an instance of HTTParty::Response" do
	 		expect(storyResource.stories_by_project("5FA0BB2EB47B24832C250EB73431AB2F").class).to eq(HTTParty::Response) 
	 	end

	  it "shoould have respond with 200 " do
	 		expect(storyResource.stories_by_project("5FA0BB2EB47B24832C250EB73431AB2F").header.code).to eq("200") 
	 	end	  

	  it "should contain UserStories" do
			expect(storyResource.stories_by_project("5FA0BB2EB47B24832C250EB73431AB2F").parsed_response["UserStories"]).not_to be_nil 
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

	describe "#story_by_ids", :vcr => true do
		it "should be an instance of HTTParty::Response" do
				storyResource.story_by_ids([182,183]).each do |response|
				expect(response).to eq Targetprocess::Userstory.new(:id => 182, :name => "Edit Area", :effort => 8, :owner_id => 7, :owner_full_name => "Jack Blue", :project_id => 2, :release_id => 6, :priority => "Great", :entity_state => "Planned")
			end
	 	end

	 #  it "shoould have respond with 200 " do
	 #  	storyResource.story_by_ids([182,183]).each do |response|
	 # 			expect(response.header.code).to eq("200") 
	 # 		end
	 # 	end	  

	 #  it "should contain UserStories" do
	 #  	storyResource.story_by_ids([182,183]).each do |response|
		# 		expect(response.parsed_response["UserStory"]).not_to be_nil 
		# 	end
		# end

		# it "should return array of errors" do
		# 	storyResource.story_by_ids(['a','b']).each do |error|
		# 		expect(error[:status]).to eq("BadRequest")
		# 		expect(error[:message]).to match(/Invalid id:.*/)
		# 		expect(error[:type]).to eq("Tp.Web.Mvc.Exceptions.BadRequestException")
		# 	end
		# end

	end	

end



