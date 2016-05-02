class GroupsController < ApplicationController

  def index
    @groups = Group.all
    @states = CS.states(:IN)
  end

  def create
    if Group.find_by_name(params[:group][:name]).present?
      render json: "Group with this name already exists", status: 500
      return
    end
    @group = Group.new(group_params)
    @group.user = User.find_by_employee_id(params[:group][:user_id])
    @group.client_id = params[:group][:client_id]
    @group.save
    render json: {}, status: 201 
  end

  def show
    @group = Group.find(params[:id])
    @approvers = []
    if @group.user.present?
      @approvers = User.where(:client_id => @group.user.client.id, :role_type => "approver")
    end
  end

  def update
    @group = Group.find(params[:id])
    @group.update!(group_params)
    if params[:group][:user_id].present?
      @group.user = User.find(params[:group][:user_id])
      @group.save
    end
    if current_user.client.present?
      redirect_to "/clients/#{current_user.client.id}#groups", :flash => {:notice => "Successfully updated Group"}
    else
      redirect_to "/groups/#{@group.id}", :flash => {:notice => "Successfully updated group"}
    end
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
