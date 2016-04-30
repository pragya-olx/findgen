class Subgroup < ActiveRecord::Base
  belongs_to :group
  belongs_to :client
  belongs_to :user
end
