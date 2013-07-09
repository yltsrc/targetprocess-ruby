require 'httparty'

module Targetprocess
	class UserStoryResource
	 
	  include HTTParty
	  format :xml

	  def initialize(u, p, uri)
	  	@uri = uri + (uri[-1] == '/' ? "" : "/")
	    @auth = {:username => u, :password => p}
	  end

	  def request(url, options={}, acid="")
	  	options.merge!(:basic_auth => @auth)
	  	options.merge!(:body => {:acid => acid}) unless acid.empty?
	  	self.class.get(@uri+url, options)
	  end

	  # Methods like "all_something" returns first 25 objects by default, you can pass to it :body =>{take: "amount"} to get more.
	  def all_stories(options={})
	    request("api/v1/UserStories", options)["UserStories"]["UserStory"].collect! { |userstory| Userstory.new(userstory) }
	  end

	  def stories_by_project(acid,options={})
	    request("api/v1/userstories", options, acid)["UserStories"]["UserStory"].collect! { |userstory|	Userstory.new(userstory) }
	  end

	  def story_by_ids(*args)
      args.collect!{ |id| Userstory.new(request("api/v1/userstories/#{id}")["UserStory"]) }
	  end

	  def find_story(id, options={})
	  	Userstory.new(request("api/v1/userstories/#{id}", options)["UserStory"])
	  end

	  def users_by_ids(*args)
	  	args.collect!{ |id| User.new(request("api/v1/users/#{id}")["User"]) }
	  	return args.size == 1 ? args.first : args
	  end

	  def all_users(options={})
	  	request("api/v1/users", options)["Users"]["User"].collect! { |user|	User.new(user) }
	  end

	  def find_user(id, options={})
	  	User.new(request("api/v1/users/#{id}", options)["User"])
	  end

	  def all_tasks(options={})
	  	request("api/v1/tasks", options)["Tasks"]["Task"].collect! { |task| Task.new(task) }
		end

	  def story_tasks(story_id, options={})
	    a = request("api/v1/userstories/#{story_id}/tasks", options)["Tasks"]["Task"].collect! { |task| Task.new(task) }
	  end

	  def tasks_by_ids(*args)
	  	args.collect!{ |id| Task.new(request("api/v1/tasks/#{id}")["Task"])}
	  end

	  def find_task(id, options={})
	  	Task.new request("api/v1/tasks/#{id}", options)["Task"]
	  end

	  def bugs_by_project(acid, options={})
	    request("api/v1/bugs", options, acid)
	  end

	end
end
