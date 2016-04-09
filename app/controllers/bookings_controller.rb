class BookingsController < ApplicationController

	def show
      @booking = Booking.find(params[:id])
  	end

  	def index
  		if params[:status].nil?
  			render json: Booking.where(:status => "completed").to_json, status: 201	
  			return
  		end

      bookings = nil

      if params[:client_id].present?
        bookings = Booking.where(:status => params[:status]).where(:client_id => params[:client_id])
      else
        bookings = Booking.where(:status => params[:status])
      end

      render json: bookings, status: 201
  	end

	def new

	end

	def create
	  booking = Booking.new(params.require(:booking).permit(:name, :location,:start_date,:end_date,:gen_type))
	  booking.status = "pending"
    booking.user = current_user
    booking.client = Client.find(params[:client_id])

	  booking.save
	  render json: Booking.where(:status => "pending").to_json, status: 201
	end

end