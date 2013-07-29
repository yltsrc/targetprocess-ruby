require "spec_helper"

describe "entities", vcr: true do
  Targetprocess::ENTITIES.each do |entity|
    describe "Targetprocess::#{entity}".constantize do
      it_behaves_like "an entity"
    end
  end 
end
