module Targetprocess
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

  ENTITIES.each do |name|
    eval "class #{name}; include EntityCommons; end"
  end
end
