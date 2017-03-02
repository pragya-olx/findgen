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
    users.includes(:subgroup)
    render json: users.to_json(include: :subgroup), status: 201 
  end

  def new
    @user = User.new 
  end



  def create
    begin
      existing_user = User.find_by_email(params[:user][:email])
      if existing_user.present?
        render json: "User already exists with this email", status: 500
        return
      end
      if params[:user][:employee_id].present?
        existing_user = User.find_by_employee_id(params[:user][:employee_id])
        if existing_user.present?
          render json: "User already exists with this employee id", status: 500
          return 
        end
      end

      @user = User.new(params.require(:user).permit(:name,:location,:email,
        :phone_number,:role_type,:state,:city, :employee_id, :approver_type))

      @user.role_type = @user.role_type.downcase
      @user.encrypted_password = (0...8).map { (65 + rand(26)).chr }.join
      if !params[:user][:client_id].blank?
        @user.client = Client.find(params[:user][:client_id])
      end
      if params[:user][:subgroup_id].present?
        @user.subgroup = Subgroup.find(params[:user][:subgroup_id])
      end

      @user.save
      redirect_to "/users/#{@user.id}", :flash => {:notice => "Successfully created user"}
      
    rescue => e
      Rails.logger.error e.message
      render json: e.message, status: 500
    end
    
  end

  def show
    @user = User.find(params[:id])
    if @user.client.present?
      @subgroups = Subgroup.where(:client_id => @user.client.id)
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update!(params.require(:user).permit(:name, :email, :phone_number, 
      :encrypted_password, :employee_id, :role_type, :subgroup_id,
      :approver_type))
    Rails.logger.info("Is Approver = #{@user.is_approver?}")
    if !@user.is_approver?
      Rails.logger.info("Not Approver = #{@user.is_approver?}")
      @user.approver_type = nil
      @user.save
    end
    if @user.client.present?
      redirect_to "/clients/#{@user.client.id}#users", :flash => {:notice => "Successfully updated user"}
    else
      redirect_to "/users/#{@user.id}", :flash => {:notice => "Successfully updated user"}
    end
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

  def check_if_employee_exists
    existing_user = User.find_by_email(params[:user][:email])
      if existing_user.present?
        render json: "User already exists with this email", status: 500
        return
      end
      if params[:user][:employee_id].present?
        existing_user = User.find_by_employee_id(params[:user][:employee_id])
        if existing_user.present?
          render json: "User already exists with this employee id", status: 500
          return 
        end
      end
    render json: {}, status: 201 
  end

end
