class BookingsController < ApplicationController

	def show
      @booking = Booking.find(params[:id])
  	end

  	def index
  		if params[:status].nil?
  			render json: Booking.where(:status => "completed").to_json, status: 201	
  			return
  		end

  	  if params[:status] == "approved"
  	  	render json:  Booking.where(:status => "approved").where("end_date > ?", Time.now).to_json, status: 201
  	  elsif params[:status] == "pending"
  	  	render json: Booking.where(:status => "pending").to_json, status: 201
  	  else
  	  	render json: Booking.where(:status => "completed").to_json, status: 201	
  	  end
  	end

	def new

	end

	def create
	  booking = Booking.new(params.require(:booking).permit(:name, :location,:start_date,:end_date,:gen_type))
	  booking.status = "pending"

	  booking.save
	  render json: Booking.where(:status => "pending").to_json, status: 201
	end

end