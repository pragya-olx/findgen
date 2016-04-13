class LocationsController < ApplicationController
	def index
		@locations = Location.all
		@states = CS.states(:IN)
		@cities = Location.pluck(:city)
		respond_to do |format|
			format.json {render :json => Location.all, :status => 200}
			format.html
		end

	end

	def create
		@location = Location.where(:state => params[:state], :city => params[:city]).first
		if @location.nil?
	    	@location = Location.new(params.permit(:state,:city,:fixed))
	    else
	    	@location.fixed = params[:fixed]
	    end
	    @location.save
	    render json: {}, status: 201 
  end
end
