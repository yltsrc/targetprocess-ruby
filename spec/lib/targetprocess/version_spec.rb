require 'spec_helper'

describe "Targetprocess::VERSION" do
  it "must be defined" do
    expect(TargetProcess::VERSION).to_not be_nil
  end
end
