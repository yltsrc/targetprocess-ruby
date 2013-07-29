require "targetprocess/entity_commons"

module Targetprocess
  ENTITIES = YAML.load_file(EntityCommons::ATTR_FILE).keys.collect! do |key|
    key.titleize 
  end

  ENTITIES.each do |name|
    eval "class #{name}; include EntityCommons; end"
  end
end
