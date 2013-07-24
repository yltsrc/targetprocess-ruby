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
end
