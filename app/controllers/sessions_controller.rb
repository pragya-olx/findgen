class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :destroy, :forgot_password]

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

  def email_body(user)
    body = "<html> User #{user.name}"
    body += "<br> Your password is - #{user.encrypted_password}"
    body += "</html>"
  end

  def forgot_password
    user = User.find_by(email: params[:email].downcase)
    if user.present?
      to = user.email
      begin
        RestClient.post "https://api:key-ad59eb535febe7c7ff00bc1b64bf2b25@api.mailgun.net/v3/iv-genset.com/messages",
          :from => "Innovatiview <info@innovatiview.com>",
          :to => to,
          :subject => "Innovatiview Password Recovery",
          :html => email_body(user)
      rescue => error
        Rails.logger.error "Unable to send password recovery email to user #{to}"
      end
      render json: {}, status: 200 
    else
      render json: {}, status: 500
    end 
  end
end
