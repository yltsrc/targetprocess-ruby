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

  init_code = ""
  ENTITIES.each do |name|
    init_code += "class #{name}; include EntityCommons; end \n"
  end

  eval init_code
end
