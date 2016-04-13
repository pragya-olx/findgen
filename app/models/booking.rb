class Booking < ActiveRecord::Base

	belongs_to :user, :class_name => "User"
  	belongs_to :vendor, :class_name => "User"
	belongs_to :client

end