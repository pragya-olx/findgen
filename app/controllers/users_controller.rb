class UsersController < ApplicationController

  def index
    users = nil
    if params[:role_type] == "admin"
      users = User.where(:role_type => "admin")
    elsif params[:role_type] == "spoc"
      users = User.where(:role_type => "spoc")
    elsif params[:role_type] == "vendor"
      users = User.where(:role_type => "vendor")
    elsif params[:role_type] == "approver"
      users = User.where(:role_type => "approver")
    elsif params[:role_type] == "employee"
      users = User.where(:role_type => "employee")
    else
      users = User.where(:role_type => "owner")
    end

    if !params[:client_id].blank?
      users = users.where(:client_id => params[:client_id])
    end

    render json: users, status: 201 
  end

  def new
    @user = User.new 
  end

  def create
    @user = User.new(params.require(:user).permit(:name,:location,:email,:phone_number,:role_type,:state,:city, :employee_id))
    @user.role_type = @user.role_type.downcase
    @user.encrypted_password = (0...8).map { (65 + rand(26)).chr }.join
    if !params[:user][:client_id].blank?
      @user.client = Client.find(params[:user][:client_id])
    end
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

  def add_operator
    @user = User.find(params[:id])
    Operator.create(:name => params[:name],
      :phone_number => params[:phone_number],
      :vendor_id => @user.id
    )
    render json: {}, status: 200
  end

  def update_password
    @user = User.find(params[:id])
    @user.encrypted_password = params[:password]
    @user.save
    render json: {}, status: 200

  end

end
