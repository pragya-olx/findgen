class UserMailer < ActionMailer::Base
  default from: 'maygupta@groupon.com'

  def booking_update(booking)
    if booking.status == "rejected"
    	body = "Your booking has been rejected"
    	mail(to: booking.user.email, 
	    	subject: 'Booking Status Updated',
	    	body: "#{booking.name} current status is #{booking.status}"
	    )
    else
		body = "#{booking.name} current status is #{booking.status} and assigned to Vendor : #{booking.vendor.name}"
	    mail(to: [booking.user.email, booking.vendor.email], 
    		subject: 'Booking Status Updated',
    		body: body
    	)
    end
  end

  def booking_create(booking)
  	mail(to: booking.user.email, 
    	subject: 'Booking Created',
    	body: "#{booking.name} is created and waiting to be approved"
    )
  end
end