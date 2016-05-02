class SubgroupsController < ApplicationController

  def index
    @subgroups = Subgroup.all
    @states = CS.states(:IN)
  end

  def create
    if Subgroup.find_by_name(params[:subgroup][:name]).present?
      render json: "Subgroup with this name already exists", status: 500
      return
    end
    @subgroup = Subgroup.new(subgroup_params)
    @subgroup.user = User.find_by_employee_id(params[:subgroup][:user_id])
    @subgroup.group = Group.find(params[:subgroup][:group_id])
    @subgroup.client_id = params[:subgroup][:client_id]
    @subgroup.save
    render json: {}, status: 201 
  end

  def show
    @subgroup = Subgroup.find(params[:id])
    @groups = Group.all
    @approvers = []
    if @subgroup.user.present?
      @approvers = User.where(:client_id => @subgroup.user.client.id, :role_type => "approver")
    end
  end

  def update
    @subgroup = Subgroup.find(params[:id])
    @subgroup.update!(subgroup_params)

    if params[:subgroup][:user_id].present?
      @subgroup.user = User.find(params[:subgroup][:user_id])
    end
    if params[:subgroup][:group_id].present?
      @subgroup.group = Group.find(params[:subgroup][:group_id])
    end
    @subgroup.save

    if current_user.client.present?
      redirect_to "/clients/#{current_user.client.id}#subgroups", :flash => {:notice => "Successfully updated Subgroup"}
    else
      redirect_to "/subgroups/#{@subgroup.id}", :flash => {:notice => "Successfully updated Subgroup"}
    end
  end

  def subgroup_params
    params.require(:subgroup).permit(:name)
  end
end
