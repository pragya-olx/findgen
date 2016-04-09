class UsersController < ApplicationController

  def index
      if params[:role_type] == "admin"
        render json:  User.where(:role_type => "admin").to_json, status: 201
      elsif params[:role_type] == "spoc"
        render json: User.where(:role_type => "spoc").to_json, status: 201
      elsif params[:role_type] == "vendor"
        render json: User.where(:role_type => "vendor").to_json, status: 201
      elsif params[:role_type] == "owner"
        render json: User.where(:role_type => "owner").to_json, status: 201 
      end
  end

  def new
    @user = User.new 
  end

  def create
    @user = User.new(params.require(:user).permit(:name,:location,:email,:phone_number,:role_type))
    @user.role_type = @user.role_type.downcase
    @user.client = Client.find(params[:client_id])
    if @user.save
      flash[:notice] = "You signed up successfully"
      flash[:color]= "valid"
    else
      flash[:notice] = "Form is invalid"
      flash[:color]= "invalid"
    end
    render json: {}, status: 201 
  end

  def show
    @user = User.find(params[:id])
  end

end
