require 'targetprocess/version'
require 'targetprocess/configuration'
require 'targetprocess/api_errors'
require 'targetprocess/api_client'
require 'targetprocess/base'

module Targetprocess

  def self.configuration
    msg = "Targetprocess is not configured yet"
    @configuration || raise(Targetprocess::ConfigurationError.new(msg))
  end

  def self.client
    @client ||= APIClient.new
  end

  def self.configure
    @configuration ||= Configuration.new
    yield(@configuration)
  end

  ENTITIES = ["Task", "Userstory", "Feature", "Bug", "User", "Project", 
            "Release", "Iteration", "Request", "Testcase", "Impediment", 
            "Comment", "Process", "Priority", "Severity", "Entitystate", 
            "Program", "Testplan", "Testplanrun", "Testcaserun", "Time", 
            "Assignment", "Role", "Roleeffort", "Projectmember", "Build", 
            "Company", "Customactivity", "Attachment", "Entitytype", 
            "General", "Assignable", "Generaluser", "Requesttype", "Message",
             "Messageuid", "Milestone", "Relation", "Relationtype", 
             "Requester", "Revision", "Revisionfile", "Tag", "Team", 
             "Teamiteration", "Teammember", "Teamproject"]

  init_code = ""
  ENTITIES.each do |name|
    init_code += "class #{name}; include Base; end \n"
  end

  eval init_code
  
end
