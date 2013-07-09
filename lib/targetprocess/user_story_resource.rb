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

	  def request(url, options={}, acid="")
	  	options.merge!(:basic_auth => @auth)
	  	options.merge!(:body => {:acid => acid}) unless acid.empty?
	  	self.class.get(@uri+url, options)
	  end

	  def all_stories(options={})
	    request("api/v1/UserStories?take=100000")["UserStories"]["UserStory"].collect! { |userstory| Userstory.new(userstory) }
	  end

	  def stories_by_project(acid,options={})
	    request("api/v1/userstories/", options, acid)["UserStories"]["UserStory"].collect! { |userstory|	Userstory.new(userstory) }
	  end

	  def story_by_ids(*args)
      args.collect!{ |id| Userstory.new(request("api/v1/userstories/#{id}")["UserStory"]) }
      return args.size == 1 ? args.first : args
	  end

	  def users_by_ids(*args)
	  	args.collect!{ |id| User.new(request("api/v1/users/#{id}")["User"]) }
	  	return args.size == 1 ? args.first : args
	  end

	  def all_users(options={})
	  	request("api/v1/users?take=100000", options)["Users"]["User"].collect! { |user|	User.new(user) }
	  end

	  def story_tasks(id)
	    check_for_errors request("api/v1/userstories/#{id}/tasks/?take=100000")
	  end

	  def bugs_by_project(acid, options={})
	    request("api/v1/bugs", options, acid)
	  end

	end
end
