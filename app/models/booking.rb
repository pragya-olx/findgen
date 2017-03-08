
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

   def is_cancelled?
      status == "cancelled"
   end

   def invoice_url
      "http://s3.amazonaws.com/#{ENV['S3_BUCKET_NAME']}/image/#{self.id}/invoice.jpg"
   end

   def email_body
      body = "<html> Booking #{self.name} :"
      body += "<a href='http://generator.innovatiview.com/bookings/#{self.name}'>http://generator.innovatiview.com/bookings/#{self.name}</a>"
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
      begin
        RestClient.post "https://api:key-ad59eb535febe7c7ff00bc1b64bf2b25"\
        "@api.mailgun.net/v3/iv-genset.com/messages",
        :from => "Innovatiview <info@innovatiview.com>",
        :to => to,
        :subject => subject,
        :html => email_body
      rescue => e
        Rails.logger.error "There was an error in sending email to #{to} for booking - #{self.name} due to #{e}"
      end
    end
  end

  def booking_data
    match_lisp = Lisp.find_by_code(self.lisp)
    [
      ["ID", self.name],
      #["Location", self.location],
       ["Submitted On", self.created_at.to_formatted_s(:long)],
      ["Required_on", self.start_date.to_formatted_s(:long)],
      ["Time In", self.time_in],
      ["Time Out", self.time_out],
      ["Generator", self.gen_type],
      ["KVA", self.kva],
      ["Zone", match_lisp.zone],
      ["State", match_lisp.state],
      ["City", match_lisp.city],
      ["LISP Code", match_lisp.code],
      ["LISP Name", match_lisp.name],
      ["LISP Address", match_lisp.address],
      ["Assessment", self.assessment]
    ]
  end

  def short_spoc_remarks
    if self.spoc_remarks.size > 10
      return spoc_remarks[0..9] + "..."
    end
    self.spoc_remarks
  end

  def spoc_data
    match_spoc_subgroup = Subgroup.find_by_id(self.user.subgroup_id)
    [
      ["Employee Name", self.user.name],
      ["Employee Id", self.user.employee_id],
      ["Email ID", self.user.email],
      ["Phone Number", self.user.phone_number],
      ["Role Type", self.user.role_type],
      ["Spoc Remarks", self.spoc_remarks]
    ]

  end

  def rep_data
  #match_rep_subgroup = Subgroup.find_by_id(self.rep.subgroup_id)
    [
      ["Name", self.rep.name],
      ["Employee Id", self.rep.employee_id],
      ["Email", self.rep.email],
      ["Phone number", self.rep_phone_number],
      ["Role Type", self.rep.role_type],
    ]
  end

  def vendor_data
    if self.vendor.present? and self.operator.present?
      [
        ["Vendor Name", self.vendor.name],
        ["Operator", self.operator.name],
        ["Operator Phone number", self.operator.phone_number]
      ]
    else
      []
    end
  end


  def cost_data
    if self.actual_hours.present?
    [
      ["Running hours", self.actual_hours],
    ]
  else
    [
      ["Running hours", "N/A"],
    ]
  end

  end

  def ui_status
    case self.status
      when "cancelled"
        "Cancelled"
      when "rejected"
        "Rejected"
      when "client_approved"
        "Pending IV Accept"
      when "pending"
        "Pending Approval"
      when "accepted"
        "Accepted"
      else
        "Completed"
      end
  end

  def show_invoice_update?
    !self.hours_status.present? or ( self.hours_status.present? and self.hours_status != "Accept" )
  end

end