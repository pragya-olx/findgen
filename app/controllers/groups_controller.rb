class GroupsController < ApplicationController

  def index
    @groups = Group.all
    @states = CS.states(:IN)
  end

  def create
    @group = Group.new(group_params)
    @group.user = User.find_by_employee_id(params[:group][:user_id])
    @group.client_id = params[:group][:client_id]
    @group.save
    render json: {}, status: 201 
  end

  def show
    if params[:id] != 'unknown'
      @group = Group.find(params[:id])
    else
      @group = Group.find_by_code(params[:code])
      if @group.nil?
        redirect_to '/groups'
      end
    end
  end

  def update
    @group = Group.find(params[:id])
    @group.update!(group_params)
    redirect_to '/groups', , :flash => {:notice => "Successfully updated group"}
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
