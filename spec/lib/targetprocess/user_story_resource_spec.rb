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
				story = Targetprocess::Userstory.new(:id=>182, :name=>"Edit Area 1", :release=>{:id=>58, :name=>"Release #2"}, :project=>{:id=>13, :name=>"Tau Product Web Site - Scrum #1"}, :priority=>{:id=>2, :name=>"Great"}, :owner=>{:id=>7, :firstname=>"Jack", :lastname=>"Blue"}, :entitytype=>{:id=>4, :name=>"UserStory"}, :entitystate=>{:id=>46, :name=>"Open"}, :lastcommenteduser=> {:id=>1, :firstname=>"Administrator", :lastname=>"Administrator"}, :description=>nil, :createdate=>"2013-06-18T09:20:00", :modifydate=>"2013-07-08T08:01:27", :startdate=>"2013-07-08T05:05:19", :enddate=>nil, :lastcommentdate=>"2013-07-08T02:36:54", :lastcommenteduser_firstname => "Administrator", :lastcommenteduser_id=>1, :lastcommenteduser_lastname=>"Administrator", :tags=> ["asd", "qwe"], :numericpriority=>59.875, :effort=>8.0, :effortcompleted=>0.0, :efforttodo=>8.0, :timespent=>0.0, :timeremain=>8.0, :initialestimate=>8.0, :entitytype_id=>4, :entitytype_name=>"UserStory", :owner_id=>7, :owner_firstname=>"Jack", :owner_lastname=>"Blue", :project_id=>13, :project_name=> "Tau Product Web Site - Scrum #1", :release_id=>58, :release_name=>"Release #2", :iteration_id=> 116, :iteration=>{:id=>116, :name=>"Sprint #2.3"}, :teamiteration=>nil, :team=>nil, :priority_id=>2, :priority_name=>"Great", :entitystate_id=>46, :entitystate_name=>"Open", :feature=>nil, :customfields=>nil)
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

	describe "#users_by_ids", :vcr => true do
		it "should return an Targetprocess::User instance or array of instances" do
			first = storyResource.users_by_ids(1)
			second = storyResource.users_by_ids(1,9,8)
			expect(first.class).to eq(Targetprocess::User)
			expect(second.class).to eq Array
			second.each { |instance| expect(instance.class).to eq(Targetprocess::User)  }
		end

		it "should be equal to User instance" do
			user = Targetprocess::User.new(:id => 1, :kind => "User", :firstname => "Administrator", :lastname => "Administrator", :email => "dm.brodnitskiy@gmail.com", login: "admin", createdate: "2013-07-02T00:00:25.457", modifydate: "2013-07-09T02:52:27",
						 deletedate: nil, isactive: true, isadministrator: true, weeklyavailablehours: 40.0000, currentallocation: 220, currentavailablehours: 0.0000, availablefrom: nil, availablefutureallocation: 0, availablefuturehours: 0.0000,
						 isobserver: true, skills: ["ruby", "rails"], activedirectoryname: "test", role_id: 1, role_name: "Developer", role: {id: 1, name: "Developer"} )
			response_user = storyResource.users_by_ids(1)
			expect(response_user).to eq(user)
		end

	end

	describe "#all_users" , :vcr => true do
		it "should return an array of Targetprocess::User instances" do
			response = storyResource.all_users
			expect(response.class).to eq(Array) 
			response.each { |instance| expect(instance.class).to eq(Targetprocess::User) }
		end
	end

end
