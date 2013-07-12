require 'spec_helper'

describe "Assignable::constants" do
  context "should be defined" do
    it { expect(Assignable::ALL_VARS).to_not be_nil  }
    it { expect(Assignable::FLOAT_VARS).to_not be_nil }
    it { expect(Assignable::INT_VARS).to_not be_nil }
    it { expect(Assignable::ARR_VARS).to_not be_nil }
    it { expect(Assignable::DATE_VARS).to_not be_nil }
    it { expect(Assignable::ALL_MISSINGS).to_not be_nil }
  end
end
