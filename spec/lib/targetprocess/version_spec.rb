require 'spec_helper'

describe "Targetprocess::VERSION" do
  it "must be defined" do
    expect(Targetprocess::VERSION).to_not be_nil
  end
end
