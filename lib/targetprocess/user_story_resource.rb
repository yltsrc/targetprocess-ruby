require 'httparty'

module Targetprocess
	class UserStoryResource
	  include HTTParty
	  format :xml
	  def initialize(u, p, uri)
	  	if uri[-1] == '/'
	  		@uri = uri
	  	else
	  		@uri = uri + '/'
	  	end
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
	    check_for_errors self.class.get(@uri + "api/v1/UserStories/", options)
	  end

	  def stories_by_project(acid,options={})
	    options.merge!(:basic_auth => @auth, :body => {:acid => acid})
	    check_for_errors self.class.get(@uri + "api/v1/userstories/", options)
	  end

	  def bugs_by_project(acid, options={})
	    options.merge!(:body => {:acid => acid}) if acid
	    self.class.get(@uri + "api/v1/bugs", options)
	  end


	  def story_by_ids(ids)
	    case ids
	    when Fixnum
	        check_for_errors self.class.get(@uri + "api/v1/userstories/#{ids}")
	    when Array
	        ids.collect!{|id| Userstory.new(check_for_errors(self.class.get(@uri + "api/v1/userstories/#{id}")).parsed_response["UserStory"])}
	        ids
	    else
	      puts 'wrong input specify id or array of ids'
	    end
	  end

	  def story_tasks(id)
	    check_for_errors self.class.get(@uri + "api/v1/userstories/#{id}/tasks/")
	  end

	end
end
