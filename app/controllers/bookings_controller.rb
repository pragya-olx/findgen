class BookingsController < ApplicationController

  include CostCalculator

	def show
      @booking = Booking.find(params[:id])
      if @booking.lisp.present? and @booking.kva.present?
        @per_day = per_day_cost(@booking.lisp, @booking.kva)
        @per_hour = per_hour_cost(@booking.lisp, @booking.kva)
      end

      if @booking.actual_days.present? and @booking.actual_hours.present?
        total = @booking.actual_days.to_i*@per_day + @booking.actual_hours*@per_hour
        total += 1500 if @booking.is_mobile?
        @management_charges = total * 0.1
        @booking.cost = total + @management_charges
        @booking.save
      end
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

  def cancel
    booking = Booking.find(params[:id])
    booking.status = "cancelled"
    #d = DateTime.parse(booking.start_date + "T" + booking.time_in + "+05:30")
    #next_day = 1.day.from_now
    render json: {}, status: 201
  end

	def new
	end

	def create
	  booking = Booking.new(params.require(:booking).permit(:start_date, :end_date, :gen_type, :time_in, :time_out, :lisp, :kva))

	  booking.status = "pending"
    booking.user = current_user
    booking.client = Client.find(params[:booking][:client_id])
    booking.rep = User.find(params[:booking][:rep_id])
    booking.name = "#{booking.client.name}_#{booking.user.name}"
    booking.location = booking.client.location
	  booking.save
    booking.name = "#{booking.name}_#{booking.id}"
    booking.save
    
    #UserMailer.booking_create(booking).deliver

	  render json: {}, status: 201
	end

  def update
    booking = Booking.find(params[:id])
    booking.update!(booking_params)
    if booking.status == "approver_approved" and booking.vendor_id.present?
      booking.status = "approved"
      booking.save
    end
    if booking.status == "approved" and booking.slip.present?
      booking.status = "completed"
      booking.save
    end
    if booking_params[:actual_days].present?
      booking.cost = booking_params[:actual_days].to_i*per_day_cost(booking.lisp, booking.kva) + booking_params[:actual_hours].to_i*per_hour_cost(booking.lisp, booking.kva)
      booking.cost += 1500 if booking.is_mobile?
      booking.cost += 0.1*booking.cost
      booking.save
    end

    #UserMailer.booking_update(booking).deliver
    redirect_to booking
  end

  private

  def booking_params
    params.require(:booking).permit(:name, :email,:start_date,:end_date,:status, :user_id, :vendor_id, :slip, :actual_days, :actual_hours)
  end

end