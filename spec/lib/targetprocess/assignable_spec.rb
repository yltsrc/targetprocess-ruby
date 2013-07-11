require 'spec_helper'

describe "Assignable::constants" do
  context "should be defined" do
    it { expect(Assignable::ALL_VAR).to_not be_nil  }
    it { expect(Assignable::FLOAT_VAR).to_not be_nil }
    it { expect(Assignable::INT_VAR).to_not be_nil }
    it { expect(Assignable::ARR_VAR).to_not be_nil }
    it { expect(Assignable::DATE_VAR).to_not be_nil }
    it { expect(Assignable::ALL_MISSINGS).to_not be_nil }
  end
end
