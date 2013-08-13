require 'target_process/version'
require 'target_process/configuration'
require 'target_process/api_error'
require 'target_process/api_client'
require 'target_process/base'

module TargetProcess
  class ConfigurationError < StandardError; end

  def self.configuration
    msg = "TargetProcess is not configured yet"
    @configuration || raise(TargetProcess::ConfigurationError.new(msg))
  end

  def self.client
    @client ||= APIClient.new
  end

  def self.configure
    @configuration ||= Configuration.new
    yield(@configuration)
  end

  def self.context(options={})
    options.each { |item| item.to_s.slice(1..-2) if item.is_a?(Array)}
    TargetProcess.client.get("context/", options)
  end

  ENTITIES = ["Task", "UserStory", "Feature", "Bug", "User", "Project",
            "Release", "Iteration", "Request", "TestCase", "Impediment",
            "Comment", "Process", "Priority", "Severity", "EntityState",
            "Program", "Testplan", "TestPlanRun", "TestCaseRun", "Time",
            "Assignment", "Role", "RoleEffort", "ProjectMember", "Build",
            "Company", "CustomActivity", "Attachment", "EntityType",
            "General", "Assignable", "GeneralUser", "RequestType", "Message",
             "MessageUid", "Milestone", "Relation", "RelationType",
             "Requester", "Revision", "RevisionFile", "Tag", "Team",
             "TeamIteration", "TeamMember", "TeamProject"]

  init_code = ""
  ENTITIES.each do |name|
    init_code += "class #{name}; include Base; end \n"
  end

  eval init_code
end
