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

	  def return_array_of(response, klass)
	  	response.is_a?(Hash) ? [klass.new(response)] : response.collect! { |item| klass.new(item) } 
	  end

	  # Methods like "all_something" returns first 25 objects by default, you can pass to it :body =>{take: "amount"} to get more.
	  # Due to performance reasons REST api could return only up to 1000 items in row. If you want to get next 1000 items, you can pass :body=>{:skip => 1000, :take=> 1000}
	  def all_stories(options={})
	  	return_array_of(request("api/v1/UserStories", options)["UserStories"]["UserStory"], Userstory)
	  end

	  def stories_by_project(acid,options={})
	    return_array_of(request("api/v1/userstories", options, acid)["UserStories"]["UserStory"], Userstory)
	  end

	  def story_by_ids(*args)
      args.collect!{ |id| Userstory.new(request("api/v1/userstories/#{id}")["UserStory"]) }
	  end

	  def find_story(id, options={})
	  	Userstory.new(request("api/v1/userstories/#{id}", options)["UserStory"])
	  end


	  def users_by_ids(*args)
	  	args.collect!{ |id| User.new(request("api/v1/users/#{id}")["User"]) }
	  end

	  def all_users(options={})
	  	return_array_of(request("api/v1/users", options)["Users"]["User"], User)
	  end

	  def find_user(id, options={})
	  	User.new(request("api/v1/users/#{id}", options)["User"])
	  end


	  def all_tasks(options={})
	  	return_array_of(request("api/v1/tasks", options)["Tasks"]["Task"], Task)
		end

	  def tasks_by_story(story_id, options={})
	    return_array_of(request("api/v1/userstories/#{story_id}/tasks", options)["Tasks"]["Task"], Task)
	  end

	  def tasks_by_ids(*args)
	  	args.collect!{ |id| Task.new(request("api/v1/tasks/#{id}")["Task"])}
	  end

	  def find_task(id, options={})
	  	Task.new request("api/v1/tasks/#{id}", options)["Task"]
	  end

	  def tasks_by_project(acid, options={})
	  	return_array_of(request("api/v1/tasks", options, acid)["Tasks"]["Task"], Task)
	  end


	  def all_bugs(options={})
	  	return_array_of(request("api/v1/bugs", options)["Bugs"]["Bug"], Bug)
	  end

	  def bugs_by_story(story_id, options={})
	  	return_array_of(request("api/v1/userstories/#{story_id}/bugs", options)["Bugs"]["Bug"], Bug)
	  end

	  def bugs_by_project(acid, options={})
	    return_array_of(request("api/v1/bugs", options, acid)["Bugs"]["Bug"], Bug)
	  end

	  def find_bug(id, options={})
	  	Bug.new request("api/v1/bugs/#{id}", options)["Bug"]
	  end

	  def bugs_by_ids(*args)
	  	args.collect!{ |id| Bug.new(request("api/v1/bugs/#{id}")["Bug"]) }
	  end


	  def all_features(options={})
	  	return_array_of(request("api/v1/features", options)["Features"]["Feature"], Feature)
	  end

	  def features_by_project(acid, options={})
	    return_array_of(request("api/v1/features", options, acid)["Features"]["Feature"], Feature)
	  end

	  def find_feature(id, options={})
	  	Feature.new request("api/v1/features/#{id}", options)["Feature"]
	  end

	  def features_by_ids(*args)
	  	args.collect!{ |id| Feature.new(request("api/v1/Features/#{id}")["Feature"]) }
	  end


	  def all_projects(options={})
	  	return_array_of(request("api/v1/projects", options)["Projects"]["Project"], Project)
	  end

	  # def projects_by_project(acid, options={})
	  #   return_array_of(request("api/v1/projects", options, acid)["Projects"]["Project"], Project)
	  # end

	  def find_project(id, options={})
	  	Project.new request("api/v1/projects/#{id}", options)["Project"]
	  end

	  def projects_by_ids(*args)
	  	args.collect!{ |id| Project.new(request("api/v1/projects/#{id}")["Project"]) }
	  end

	  
	  def all_releases(options={})
	  	return_array_of(request("api/v1/releases", options)["Releases"]["Release"], Release)
	  end

	  def releases_by_project(acid, options={})
	    return_array_of(request("api/v1/releases", options, acid)["Releases"]["Release"], Release)
	  end

	  def find_release(id, options={})
	  	Release.new request("api/v1/releases/#{id}", options)["Release"]
	  end

	  def releases_by_ids(*args)
	  	args.collect!{ |id| Release.new(request("api/v1/releases/#{id}")["Release"]) }
	  end


	  def all_iterations(options={})
	  	return_array_of(request("api/v1/iterations", options)["Iterations"]["Iteration"], Iteration)
	  end

	  def iterations_by_project(acid, options={})
	    return_array_of(request("api/v1/iterations", options, acid)["Iterations"]["Iteration"], Iteration)
	  end

	  def find_iteration(id, options={})
	  	Iteration.new request("api/v1/iterations/#{id}", options)["Iteration"]
	  end

	  def iterations_by_ids(*args)
	  	args.collect!{ |id| Iteration.new(request("api/v1/iterations/#{id}")["Iteration"]) }
	  end
	end
end
