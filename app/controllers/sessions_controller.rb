class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in user
      redirect_to '/'
    else
      # Create an error message.
      flash[:danger] = 'Invalid email/password combination' 
      render 'new'
    end
  end

  def email_body(user)
      body = "<html> User #{user.name} :"
      body += "<br> Your password is - #{user.encrypted_password}"
      body += "</html>"
   end

def forgot_password
    user = User.find_by(email: params[:email].downcase)
    if user
      to = user.email
       RestClient.post "https://api:key-ad59eb535febe7c7ff00bc1b64bf2b25@api.mailgun.net/v3/iv-genset.com/messages",
        :from => "Innovatiview <info@innovatiview.com>",
        :to => to,
        :subject => "User Password",
        :html => email_body(user)
 
     render json: {}, status: 200 
    else
      
     render json: {}, status: 500
    end 
  end

  def destroy
    reset_session
    redirect_to '/login'
  end
end
