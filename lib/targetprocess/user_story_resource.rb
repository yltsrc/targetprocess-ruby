require 'httparty'

module Targetprocess
	class UserStoryResource
	 
	  include HTTParty
	  format :xml

	  def initialize(u, p, uri)
	  	@uri = uri + (uri[-1] == '/' ? "" : "/")
	    @auth = {:username => u, :password => p}
	  end

	  def check_for_errors(response)
	    if response.parsed_response["Error"]
	      error = response.parsed_response["Error"]
	      {:status => error['Status'], :message => error['Message'], :type => error['Type']}  
	    else
	      response
	    end
	  end  

	  def all_stories(options={})
	    options.merge!({:basic_auth => @auth})
	    self.class.get(@uri + "api/v1/UserStories?take=100000", options)["UserStories"]["UserStory"].collect! do |userstory|
				Userstory.new(userstory)	    	
			end
	  end

	  def stories_by_project(acid,options={})
	    options.merge!(:basic_auth => @auth, :body => {:acid => acid})
	    self.class.get(@uri + "api/v1/userstories/", options).parsed_response["UserStories"]["UserStory"].collect! do |userstory|
	    	Userstory.new(userstory)
	    end
	  end

	  def story_by_ids(*args)
	  	options = {:basic_auth => @auth}
      args.collect!{ |id| Userstory.new(self.class.get((@uri + "api/v1/userstories/#{id}"), options).parsed_response["UserStory"]) }
      return args.size == 1 ? args.first : args
	  end

	  def users_by_ids(*args)
	  	options={:basic_auth => @auth}
	  	args.collect!{ |id| User.new(self.class.get(@uri + "api/v1/users/#{id}", options).parsed_response["User"]) }
	  	return args.size == 1 ? args.first : args
	  end

	  def all_users(options={})
	  	options.merge!({:basic_auth => @auth})
	  	self.class.get(@uri + "api/v1/users?take=100000", options).parsed_response["Users"]["User"].collect! do |user|
	  		User.new(user)
	  	end
	  end

	  def story_tasks(id)
	    check_for_errors self.class.get(@uri + "api/v1/userstories/#{id}/tasks/")
	  end

	  def bugs_by_project(acid, options={})
	    options.merge!(:body => {:acid => acid}) if acid
	    self.class.get(@uri + "api/v1/bugs", options)
	  end

	end
end
