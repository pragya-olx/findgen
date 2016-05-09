class BookingsController < ApplicationController

  include CostCalculator

  def show
      begin
        @booking = Booking.find(params[:id])
      rescue => e
        @booking = Booking.find_by_name(params[:id])
      end

      if @booking.lisp.present? and @booking.kva.present?
        @per_day = per_day_cost(@booking.lisp, @booking.kva)
        @per_hour = per_hour_cost(@booking.lisp, @booking.kva)
        if @booking.actual_hours.present?
          total = @per_day + @booking.actual_hours.to_i*@per_hour
          total += 1500 if @booking.is_mobile?
          @management_charges = total * 0.1
          @booking.cost = total + @management_charges
          @booking.save
        end
      end
      @booking_updates = BookingUpdate.where(:booking_id => @booking.id)
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
    from_status = booking.ui_status
    booking.status = "client_approved"
    booking.save
    add_update_track_record(booking, from_status, booking.ui_status)
    post_approve(booking)
    render json: {}, status: 201
  end

  def post_approve(booking)
    booking.notify("Approved booking #{booking.name}", 
          [booking.user.email, booking.rep.email])
  end

  def accept
    booking = Booking.find(params[:id])
    from_status = booking.ui_status
    booking.status = "accepted"
    booking.vendor_id = params[:vendor_id]
    booking.owner_remarks = params[:owner_remarks]
    booking.operator = Operator.find(params[:operator_id])
    booking.save
    post_accept(booking)
    add_update_track_record(booking, from_status, booking.ui_status)
    render json: {}, status: 201
  end

  def post_accept(booking)
    booking.notify("Vendor Details #{booking.name}", 
          [booking.user.email, booking.rep.email])
  end

  def reject
    booking = Booking.find(params[:id])
    from_status = booking.ui_status
    booking.status = "rejected"
    booking.save
    post_reject(booking)
    add_update_track_record(booking, from_status, booking.ui_status)
    render json: {}, status: 201
  end

  def post_reject(booking)
    booking.notify("Booking #{booking.name} Rejected by Innovatiview", 
          [booking.user.email, booking.rep.email])
  end

  def cancel
    booking = Booking.find(params[:id])
    from_status = booking.ui_status
    if booking.status == "accepted"
      booking.cost = add_cancellation_charges(booking)
    end
    booking.status = "cancelled"
    booking.save

    add_update_track_record(booking, from_status, booking.ui_status)
    render json: {}, status: 201
  end

  def post_complete(booking)
    booking.notify("Verify running hours #{booking.name}", 
          [booking.user.email])
  end

  def new
  end

  def invoice
    booking = Booking.find params[:id]
    if booking.present?
      booking.invoice_status = params[:invoice_status] if params[:invoice_status].present?
      booking.hours_status = params[:hours_status] if params[:hours_status].present?
    end
    booking.save
    render json: {}, status: 201
  end

  def create
    begin
      create_params = {
        :start_date => params[:booking][:start_date],
        :gen_type => params[:booking][:gen_type],
        :time_in => params[:booking][:time_in],
        :time_out => params[:booking][:time_out],
        :lisp => params[:booking][:lisp],
        :kva => params[:booking][:kva],
        :assessment => params[:booking][:assessment],
        :spoc_remarks => params[:booking][:spoc_remarks],
        :rep_phone_number => params[:booking][:rep_phone_number]
      }
      booking = Booking.new create_params

      booking.status = "pending"
      booking.user = current_user
      booking.client = Client.find(params[:booking][:client_id])
      booking.rep = User.find_by_employee_id(params[:booking][:employee_id])
      booking.name = "IVTCS" + rand.to_s[2..7]
      booking.location = booking.client.location
      booking.save
      booking.name += booking.id.to_s
      
      if current_user.subgroup.present?
        booking.notify("New booking #{booking.name} added by #{booking.user.name}", 
          [current_user.subgroup.user.email, current_user.subgroup.group.user.email])
      end
      booking.save
    rescue => error
      render json: "Unable to create booking - #{error.message}", status: 500
      return
    end
    
    render json: {}, status: 201
  end

  def update
    booking = Booking.find(params[:id])

    from_status = booking.ui_status
    booking.update!(booking_params)

    if booking.status == "client_approved" and booking.vendor_id.present?
      booking.status = "accepted"
      post_accept(booking)
    end
    if booking.status == "accepted" and booking.actual_hours.present?
      booking.status = "completed"
      post_complete(booking)
    end
    
    add_update_track_record(booking, from_status, booking.ui_status)

    if booking_params[:actual_hours].present?
      booking.cost = per_day_cost(booking.lisp, booking.kva) + booking_params[:actual_hours].to_i*per_hour_cost(booking.lisp, booking.kva)
      booking.cost += 1500 if booking.is_mobile?
      booking.cost += 0.1*booking.cost
    end
    if params[:booking][:operator_id].present?
      booking.operator = Operator.find(params[:booking][:operator_id])
    end
    booking.save

    redirect_to '/', :flash => {:notice => "Successfully updated booking"}
  end

  private

  def add_cancellation_charges(booking)
    d = DateTime.parse(booking.start_date.to_s + "T" + booking.time_in + "+05:30")
    next_day = 1.day.from_now
    next_half_day = 0.5.day.from_now

    if next_half_day > d
      return per_day_cost(booking.lisp, booking.kva)
    elsif next_day > d
      return 0.5 * per_day_cost(booking.lisp, booking.kva)
    else
      return 0
    end
  end

  def add_update_track_record(booking, from_status, to_status)
    if from_status != to_status
      booking_update = BookingUpdate.new(:from_status => from_status, :to_status => to_status)
      booking_update.user = current_user
      booking_update.booking = booking
      booking_update.save
    end
  end

  def booking_params
    params.require(:booking).permit(:name, :email,:start_date,:status, :user_id, 
      :vendor_id, :actual_hours, :invoice, :owner_remarks)
  end

end