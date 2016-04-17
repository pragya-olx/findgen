class DashboardController < ApplicationController

	def index
		if !logged_in?
			redirect_to '/login'
		else
			if !current_user.is_owner?
				redirect_to "/clients/#{current_user.client_id}"
			end
			if params[:status].nil?
				@bookings = Booking.where(:status => ["completed", "rejected", "cancelled", "paid"])	
			else
				if params[:status] == "pending"
					@bookings = Booking.where(:status => "client_approved")
				elsif params[:status] == "accepted"
					@bookings = Booking.where(:status => "accepted")
				end
			end
		end

	end
end
