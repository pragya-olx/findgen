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

    if !params[:client_id].blank?
      bookings = Booking.where(:status => params[:status]).where(:client_id => params[:client_id])
    else
      bookings = Booking.where(:status => params[:status])
    end

    render json: bookings, status: 201
	end

  def approve
    booking = Booking.find(params[:id])
    booking.status = "approver_approved"
    booking.save
    render json: {}, status: 201
  end

	def new
	end

	def create
	  booking = Booking.new(params.require(:booking).permit(:start_date, :end_date, :gen_type, :time_in, :time_out))

	  booking.status = "pending"
    booking.user = current_user
    booking.client = Client.find(params[:booking][:client_id])
    booking.name = "#{booking.client.name}_#{booking.user.name}"
    booking.location = booking.client.location
	  booking.save
    booking.name = "#{booking.name}_#{booking.id}"
    booking.save
    
    #UserMailer.booking_create(booking).deliver

	  render json: Booking.where(:status => "pending").to_json, status: 201
	end

  def update
    booking = Booking.find(params[:id])
    booking.update!(booking_params)
    #UserMailer.booking_update(booking).deliver
    redirect_to booking
  end

  private

  def booking_params
    params.require(:booking).permit(:name, :email,:start_date,:end_date,:status, :user_id, :vendor_id, :slip)
  end

end