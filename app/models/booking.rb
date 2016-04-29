
class Booking < ActiveRecord::Base

  belongs_to :user, :class_name => "User"
  belongs_to :vendor, :class_name => "User"
  belongs_to :operator
  belongs_to :rep, :class_name => "User"
  belongs_to :client

  has_attached_file :invoice,
  :storage => :s3,
  :s3_region => 'us-east-1',
  :path => "/image/:id/invoice.jpg",
  :s3_credentials => {
    :bucket => ENV['S3_BUCKET_NAME'],
  },
  :default_url => "/images/:style/missing.png"

  validates_attachment_content_type :invoice, content_type: /\Aimage\/.*\Z/

  # mount_uploader :slip, AttachmentUploader # Tells rails to use this uploader for this model.
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

   def invoice_url
      "http://s3.amazonaws.com/#{ENV['S3_BUCKET_NAME']}/image/#{self.id}/invoice.jpg"
   end

   def email_body
      body = "<html> Booking #{self.name} :"
      body += "<a href='http://findgen.herokuapp.com/bookings/#{self.id}'>http://findgen.herokuapp.com/bookings/#{self.id}</a>"
      body += "<br> Current Status - #{self.status}"
      if self.vendor.present?
        body += "<br> Vendor - #{self.vendor.name}"
        body += "<br> Operator - #{self.operator.name}"
      end
      if self.actual_hours.present?
        body += "<br> Running hours - #{self.actual_hours}"
      end
      body += "</html>"
   end

   def notify(subject, to_list)
    to_list.each do |to|
      RestClient.post "https://api:key-ad59eb535febe7c7ff00bc1b64bf2b25"\
      "@api.mailgun.net/v3/iv-genset.com/messages",
      :from => "Innovatiview <info@innovatiview.com>",
      :to => to,
      :subject => subject,
      :html => email_body
    end
  end
    

end