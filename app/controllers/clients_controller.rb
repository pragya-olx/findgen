class ClientsController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json { render json: Client.all, status: 201 }
    end
  end

  def create
    Client.create(params.require(:client).permit(:name,:location,:email))
    render json: Client.all, status: 201 
  end

  def show
    @current_client = Client.find(params[:id])
    @lisps = Lisp.order(:code)
    @states = CS.states(:IN)
    @employees = User.where(:client_id => @current_client.id).order(:employee_id)

    unpaid_bookings = Booking.where(:client_id => params[:id], :status => ["completed"])
    cost = 0
    unpaid_bookings.each {|x| 
      if x.cost?
        cost += x.cost
      end
    }
    @current_client.balance = cost
    @current_client.save

    @bookings = Booking.where(:client_id => params[:id])

    status = params[:booking_status].nil? ? "accepted" : params[:booking_status]

    if current_user.is_approver?
      spoc_ids = SpocToApproverMapping.where("approver1_id = ? or approver2_id = ?", current_user.id,current_user.id).pluck(:spoc_id)
      @bookings = Booking.where(:status => status).where(:user_id => spoc_ids.uniq)
    else
      @bookings = Booking.where(:status => status)
    end

    if current_user.is_spoc?
      @bookings = @bookings.where(:user_id => current_user.id)
    end
  end
end
