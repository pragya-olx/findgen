class BookingsController < ApplicationController

	def show
      @booking = Booking.find(params[:id])
  	end

  	def index
  		render :json => Booking.all, :status => :ok
  	end

	def new

	end

	def create
	  @booking = Booking.new(params.require(:booking).permit(:name, :location))
	 
	  @booking.save
	  redirect_to @booking
	end

end