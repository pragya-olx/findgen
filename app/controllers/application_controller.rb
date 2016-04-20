class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def states
  	CS.states(:IN)
  end

	def cities
	  render json: CS.cities(params[:state], :IN).to_json
	end

  def operators
    render json: Operator.where(:vendor_id => params[:vendor_id]).to_json
  end
end
