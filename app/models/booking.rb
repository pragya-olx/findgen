class Booking < ActiveRecord::Base

	belongs_to :user, :class_name => "User"
  	belongs_to :vendor, :class_name => "User"
  	belongs_to :operator
  	belongs_to :rep, :class_name => "User"
	belongs_to :client

	mount_uploader :slip, AttachmentUploader # Tells rails to use this uploader for this model.
	validates :name, presence: true # Make sure the owner's name is present.

	def days
		return 1
		if self.end_date.present? and self.start_date.present?
			(self.end_date - self.start_date + 1).to_i
		else
			0
		end
	end

	def hours
		start_hours = self.time_in.split(':').first
		end_hours = self.time_out.split(':').first
		total_hours = 24*days - start_hours.to_i - (24 - end_hours.to_i)
		total_hours
	end

	def is_cancelable?
		status == "pending" or status == "accepted" or status == "client_approved"
	end

   def is_mobile?
      self.gen_type == "Mobile"
   end

   def is_completed_or_paid?
   	  status == "completed" or status == "paid"
   end

end