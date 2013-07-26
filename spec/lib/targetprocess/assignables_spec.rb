require "spec_helper"

describe "assignables", vcr: true do
  describe Targetprocess::Bug do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Comment do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Feature do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Impediment do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Project do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Release do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Iteration do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Request do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Task do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::TestCase do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::User do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::UserStory do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Process do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Priority do
    it_behaves_like "an assignable"
  end 
  describe Targetprocess::Severity do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Entitystate do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Program do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Testplan do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Testplanrun do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Testcaserun do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Time do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Assignment do
    it_behaves_like "an assignable"
  end
  describe Targetprocess::Role do
    it_behaves_like "an assignable"
  end  
  describe Targetprocess::Roleeffort do
    it_behaves_like "an assignable"
  end  
  describe Targetprocess::Projectmember do
    it_behaves_like "an assignable"
  end
end
