class DashboardController < ApplicationController

	def index
		if !logged_in?
			redirect_to '/login'
		else
			if !current_user.is_owner?
				redirect_to "/clients/#{current_user.client_id}"
			end
			@vendors = User.where(:role_type => "vendor")
			if params[:status].nil?
				@bookings = Booking.where(:status => "client_approved")
			else
				if params[:status] == "previous"
					@bookings = Booking.where(:status => ["completed", "rejected", "cancelled", "paid"])
					@show_cost = true
				elsif params[:status] == "accepted"
					@bookings = Booking.where(:status => "accepted")
				end
			end
		end

	end
end
