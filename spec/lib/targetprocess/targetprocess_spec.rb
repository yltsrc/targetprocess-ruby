require 'spec_helper'

describe "Targetprocess::constants" do
  context "should be defined" do
    it { expect(Targetprocess::URI).to_not be_nil  }
    it { expect(Targetprocess::USERNAME).to_not be_nil  }
    it { expect(Targetprocess::PASSWORD).to_not be_nil  }
  end
end
