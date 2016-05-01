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
    if params[:id] != 'unknown'
      @subgroup = Subgroup.find(params[:id])
    else
      @subgroup = Subgroup.find_by_code(params[:code])
      if @subgroup.nil?
        redirect_to '/subgroups'
      end
    end
  end

  def update
    @subgroup = Subgroup.find(params[:id])
    @subgroup.update!(subgroup_params)
    redirect_to '/subgroups'
  end

  def subgroup_params
    params.require(:subgroup).permit(:name)
  end
end
