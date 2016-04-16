class Booking < ActiveRecord::Base

	belongs_to :user, :class_name => "User"
  	belongs_to :vendor, :class_name => "User"
	belongs_to :client

	mount_uploader :slip, AttachmentUploader # Tells rails to use this uploader for this model.
   	validates :name, presence: true # Make sure the owner's name is present.

end