class DashboardController < ApplicationController

	def index
		if !logged_in?
			redirect_to '/login'
		else
			if !current_user.is_owner?
				redirect_to "/clients/#{current_user.client_id}"
			end
		end

	end
end
