class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in user
      redirect_to '/', :flash => { :notice  => "Welcome #{user.name}" }
    else
      # Create an error message.
      redirect_to '/', :flash => { :error  => "'Invalid email/password combination' " }
    end
  end

  def destroy
    reset_session
    redirect_to '/login'
  end
end
