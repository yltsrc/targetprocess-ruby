require 'targetprocess/assignable'
module Targetprocess
  class Comment 
    include Assignable

    ALL_VARS = [:id, :description, :parent_id, :createdate, :general, :general_id, 
                :general_name, :owner, :owner_id, :owner_firstname, :owner_lastname]
    
    (ALL_VARS).each { |v| attr_accessor v }
  end
end
