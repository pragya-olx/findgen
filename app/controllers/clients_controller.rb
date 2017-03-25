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
    @groups = Group.where(:client_id => @current_client.id)
    @subgroups = Subgroup.where(:client_id => @current_client.id)
    @assessments = Assessment.order(:code)
    @states = CS.states(:IN)
    @rates = Location.all.pluck(:state)
    @rates_states = @states.select do |k,v|
      @rates.include? v
    end

    @employees = User.where(:client_id => @current_client.id).order(:employee_id)
    @nom_approvers = User.where(:client_id => @current_client.id, 
      :role_type => "approver",
      :approver_type => "NOM").order(:employee_id)

    @zom_approvers = User.where(:client_id => @current_client.id, 
      :role_type => "approver",
      :approver_type => "ZOM").order(:employee_id)

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
      groups = Group.where(:user_id => current_user.id)
      spoc_ids = []
      groups.each do |group|
        if group.present?
          subgroups = Subgroup.where(:group_id => group.id).pluck(:id)
          spoc_ids += User.where(:subgroup_id => subgroups).pluck(:id)
          spoc_ids += @nom_approvers.pluck(:id)
          spoc_ids += @zom_approvers.pluck(:id)

        else
          subgroup = Subgroup.where(:user_id => current_user.id)
          if subgroup.present?
            spoc_ids += User.where(:subgroup_id => subgroup.id)
            spoc_ids += @nom_approvers.pluck(:id)
            spoc_ids += @zom_approvers.pluck(:id)

          end
        end
      end
      if spoc_ids == []
        @bookings = Booking.where(:status => status)
      else
        @bookings = Booking.where(:status => status).where(:user_id => spoc_ids.uniq)
      end
      
    else
      if status == "cancelled"
        @bookings = Booking.where(:status => ["cancelled", "rejected"])
      else
        @bookings = Booking.where(:status => status)
      end
    end

    if current_user.is_spoc?
      @bookings = @bookings.where(:user_id => current_user.id)
    end
  end

end
