require 'spec_helper'

describe Targetprocess::UserStoryResource, :vcr => true do

	subject(:storyResource) { Targetprocess::UserStoryResource.new('admin','admin','http://kamrad.tpondemand.com') }

	describe "storyResource" do
	  it "must be an instance of UserStoryResource" do 
  		expect(storyResource).to be_an_instance_of(Targetprocess::UserStoryResource)
	  end
	end

	describe "#all_stories" do
		it "should be an array" do		 
			expect(storyResource.all_stories.class).to eq(Array) 
		end

	  it "shoould contain instances of Targetprocess::Userstory " do
	    storyResource.all_stories.each do |obj|
	    	expect(obj.class).to eq(Targetprocess::Userstory)
	    end
	  end	  

	  it "should return array with 82 elements" do
	  	expect(storyResource.all_stories(body:{take: "1000000"}).count).to eq(82) 
	  end
	end

	describe "#stories_by_project" do
		it "should be an instance of Array" do
	 		expect(storyResource.stories_by_project("D6AC5DA358E9EFA3FE23C637038A54B5").class).to eq(Array) 
	 	end

	  it "shoould contain instances of Targetprocess::Userstory" do
	 		storyResource.stories_by_project("5FA0BB2EB47B24832C250EB73431AB2F").each do |obj|
	 			expect(obj.class).to eq(Targetprocess::Userstory) 
			end
	 	end	  
	end	

	describe "#story_by_ids" do
		it "should be similar to Userstory instance" do
 				response = storyResource.story_by_ids(182).first
				story = Targetprocess::Userstory.new(:id=>182, :name=>"Edit Area 1", :release=>{:id=>58, :name=>"Release #2"}, :project=>{:id=>13, :name=>"Tau Product Web Site - Scrum #1"}, :priority=>{:id=>2, :name=>"Great"},
							  :owner=>{:id=>7, :firstname=>"Jack", :lastname=>"Blue"}, :entitytype=>{:id=>4, :name=>"UserStory"}, :entitystate=>{:id=>46, :name=>"Open"}, :lastcommenteduser=> {:id=>1, :firstname=>"Administrator", 
							  :lastname=>"Administrator"}, :description=>nil, :createdate=>"2013-06-18T09:20:00", :modifydate=>"2013-07-08T08:01:27", :startdate=>"2013-07-08T05:05:19", :enddate=>nil,
							  :lastcommentdate=>"2013-07-08T02:36:54", :lastcommenteduser_firstname => "Administrator", :lastcommenteduser_id=>1, :lastcommenteduser_lastname=>"Administrator", :tags=> ["asd", "qwe"], 
							  :numericpriority=>59.875, :effort=>8.0, :effortcompleted=>0.0, :efforttodo=>8.0, :timespent=>0.0, :timeremain=>8.0, :initialestimate=>8.0, :entitytype_id=>4, :entitytype_name=>"UserStory", 
							  :owner_id=>7, :owner_firstname=>"Jack", :owner_lastname=>"Blue", :project_id=>13, :project_name=> "Tau Product Web Site - Scrum #1", :release_id=>58, :release_name=>"Release #2", :iteration_id=> 116, 
							  :iteration=>{:id=>116, :name=>"Sprint #2.3"}, :teamiteration=>nil, :team=>nil, :priority_id=>2, :priority_name=>"Great", :entitystate_id=>46, :entitystate_name=>"Open", :feature=>nil, :customfields=>nil)
				expect(response).to eq story
	 	end
	end	

	describe "#find_story" do
		it "should return Userstory instance with id == 117" do
			request_id = storyResource.find_story(117).id
			expect(request_id).to eq(117)
		end
	end


	describe "#users_by_ids" do
		it "should return an array of Targetprocess::User instances" do
			first = storyResource.users_by_ids(1)
			second = storyResource.users_by_ids(1,9,8)
			expect(first.class).to eq(Array)
			expect(second.class).to eq Array
			second.each { |instance| expect(instance.class).to eq(Targetprocess::User)  }
		end

		it "should be equal to User instance" do
			user = Targetprocess::User.new(:id => 1, :kind => "User", :firstname => "Administrator", :lastname => "Administrator", :email => "dm.brodnitskiy@gmail.com", login: "admin", createdate: "2013-07-02T00:00:25.457", modifydate: "2013-07-09T02:52:27",
						 deletedate: nil, isactive: true, isadministrator: true, weeklyavailablehours: 40.0000, currentallocation: 220, currentavailablehours: 0.0000, availablefrom: nil, availablefutureallocation: 0, availablefuturehours: 0.0000,
						 isobserver: true, skills: ["ruby", "rails"], activedirectoryname: "test", role_id: 1, role_name: "Developer", role: {id: 1, name: "Developer"} )
			response_user = storyResource.users_by_ids(1).first
			expect(response_user).to eq(user)
		end

	end

	describe "#all_users"  do
		it "should return an array of Targetprocess::User instances" do
			response = storyResource.all_users
			expect(response.class).to eq(Array) 
			response.each { |instance| expect(instance.class).to eq(Targetprocess::User) }
		end
	end

	describe "#find_user" do
		it 'should return User instance with id =3' do
			expect(storyResource.find_user(3).id).to eq(3)
		end
	end

	describe "#all_tasks" do
		it "should return an array of Targetprocess::Task instances" do
			response = storyResource.all_tasks
			expect(response).to be_an_instance_of(Array)
			response.each { |task| expect(task).to be_an_instance_of(Targetprocess::Task) }
		end
	end
	
	describe "#tasks_by_story" do
		it "should return tasks 117, 118, 119" do
			response_ids = storyResource.tasks_by_story(117).map(&:id)
			expected_ids = [118,119,120]
	 		expect(response_ids&expected_ids).to eq(response_ids) 
	 	end
	end

	describe "#tasks_by_ids" do
	 	it "should be equal to Task instance" do
	 		task = Targetprocess::Task.new(:id => 43, :release => {id: 32, name: "Release #1"}, :description => nil, :name => "Discuss development platform", :createdate =>"2013-05-12T00:00:00", 
	 					 :modifydate => "2013-05-14T10:20:00", :startdate => "2013-05-13T09:50:00", :enddate => "2013-05-14T10:20:00", :lastcommentdate => nil, :tags => nil, :priority =>{id: 11, name: "-"}, 
	 					 :numericpriority => 11, :effort => 6.0000, :effortcompleted => 6.0000, :efforttodo => 0.0000, :timespent => 6.0000, :timeremain => 0.0000, :entitytype => {id: 5, name: "Task"}, :entitytype_id => 5, 
	 					 :entitytype_name => "Task", :owner => {id: 2, firstname: "Target", lastname: "Process"}, :owner_id => 2, :owner_firstname => "Target", :owner_lastname => "Process", :lastcommenteduser => nil, 
	 					 :project => {id: 13, name: "Tau Product Web Site - Scrum #1"}, :project_id => 13, :project_name => "Tau Product Web Site - Scrum #1" , :release_id => 32, :release_name => "Release #1",
	 					 :iteration => {id: 33, name: "Sprint #1.1"}, :teamiteration => nil, :team_id => nil, :team_name => nil, :team => nil, :priority_id => 11, :priority_name => "-", :iteration_name => "Sprint #1.1",
	 					 :iteration_id => 33, :entitystate_id => 52, :entitystate => {id: 52, name: "Done"}, :entitystate_name => "Done", :customfields => nil, :lastcommenteduser_id => nil, 
	 					 :userstory => {id: 40, name: "Select development platform"}, :userstory_id => 40, :userstory_name => "Select development platform", :customfields => nil)
			response = storyResource.tasks_by_ids(43)
			expect(response.first).to eq(task)
	 	end
	end

	describe "#find_task" do
		it "should return Task instance with id = 119" do
			expect(storyResource.find_task(119).id).to eq(119) 
		end
	end

	describe "#tasks_by_project" do
		it "should return an array with 235 task" do
			request = storyResource.tasks_by_project("D6AC5DA358E9EFA3FE23C637038A54B5")
			expect(request).to be_an_instance_of(Array)
			expect(request.first).to be_an_instance_of(Targetprocess::Task)
			expect(request.first.id).to eq(235)
		end
	end

	describe "#bugs_by_project" do
		it "should be an instance of Array" do
	 		expect(storyResource.bugs_by_project("5FA0BB2EB47B24832C250EB73431AB2F").class).to eq(Array) 
	 	end

	  it "should contain Bugs" do
			expect(storyResource.bugs_by_project("5FA0BB2EB47B24832C250EB73431AB2F").first).to be_an_instance_of(Targetprocess::Bug)
		end
	end

	describe "#all_bugs"  do
		it "should be an instance of Array" do
	 		expect(storyResource.all_bugs.class).to eq(Array) 
	 	end

	  it "should contain Bugs" do
			storyResource.all_bugs.each{ |bug|  expect(bug).to be_an_instance_of(Targetprocess::Bug)}
		end
	end

	describe "#bugs_by_story" do
		it "should be an instance of Array" do
	 		expect(storyResource.bugs_by_story(234).class).to eq(Array) 
	 	end

	  it "should contain 238 Bug" do
			response = storyResource.bugs_by_story(234)
			expect(response.first).to be_an_instance_of(Targetprocess::Bug)
			expect(response.first.id).to eq(238)  
		end
	end

	describe "#find_bug" do
		it "should be an instance of Targetprocess::Bug" do
	 		expect(storyResource.find_bug(238)).to be_an_instance_of(Targetprocess::Bug) 
	 	end

	  it "should contain 238 Bug" do
			response = storyResource.find_bug(238)
			expect(response).to be_an_instance_of(Targetprocess::Bug)
			expect(response.id).to eq(238)  
		end
	end

	describe "#bugs_by_ids" do
		it "should be an instance of Array" do
	 		expect(storyResource.bugs_by_ids(238)).to be_an_instance_of(Array) 
	 	end

	  it "should contain 238 Bug" do
			response = storyResource.bugs_by_ids(238)
			expect(response.first).to be_an_instance_of(Targetprocess::Bug)  
			expect(response.first.id).to eq(238)  
		end

	  it "should contain 238, 223 Bugs" do
			response_ids = storyResource.bugs_by_ids(238, 223).map(&:id)
			expected_ids = [238, 223]
			expect(expected_ids&response_ids).to eq(expected_ids)  
		end
	end

	describe "#all_features" do
		it "should return an Array of Features" do
			response = storyResource.all_features
			expect(response).to be_an_instance_of(Array)
			response.each {|item| expect(item).to be_an_instance_of(Targetprocess::Feature) }
		end
	end

	describe "#features_by_project" do
		it "should return array of Features" do
			response = storyResource.features_by_project("D6AC5DA358E9EFA3FE23C637038A54B5")
			expect(response).to be_an_instance_of(Array)
			response.each { |item| expect(item).to be_an_instance_of(Targetprocess::Feature) }
		end
	end

	describe "#features_by_project" do
		it "should return array of Features" do
			response = storyResource.features_by_project("D6AC5DA358E9EFA3FE23C637038A54B5")
			expect(response).to be_an_instance_of(Array)
			response.each { |item| expect(item).to be_an_instance_of(Targetprocess::Feature) }
		end	
	end

	describe "#features_by_ids" do
		it "should return array of 222 Feature" do
			response = storyResource.features_by_ids(222)
			expect(response).to be_an_instance_of(Array)
			expect(response.first).to be_an_instance_of(Targetprocess::Feature) 
			expect(response.first.id).to eq(222) 
		end
	end

	describe "#find_feature" do
		it "should return 222 Feature" do
			response = storyResource.find_feature(222)
			expect(response).to be_an_instance_of(Targetprocess::Feature)
			expect(response.id).to eq(222)
		end
	end 

end

