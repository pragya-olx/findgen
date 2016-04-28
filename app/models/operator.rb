class Operator < ActiveRecord::Base

  belongs_to :vendor, :class_name => "User"
end
