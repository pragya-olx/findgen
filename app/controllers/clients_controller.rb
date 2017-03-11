class ClientsController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json { render json: Client.all, status: 201 }
    end
  end

  def create
    Client.create(params.require(:client).permit(:name,:location,:email))
    render json: Client.all, status: 201 
  end

  def show
    @current_client = Client.find(params[:id])
<<<<<<< HEAD
=======
    render json: Client.all, status: 201 
>>>>>>> c9fa9d3... fixes
  end

end
