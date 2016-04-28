class SpocToApproverMapping < ActiveRecord::Base

  belongs_to :spoc, :class_name => "User"
    belongs_to :approver1, :class_name => "User"
    belongs_to :approver2, :class_name => "User"

end