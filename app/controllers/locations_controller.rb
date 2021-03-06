class LocationsController < ApplicationController
  def index
    @locations = Location.all
    @states = CS.states(:IN)
    respond_to do |format|
      format.json {render :json => Location.all, :status => 200}
      format.html
    end

  end

  def show
    @location = Location.find(params[:id])
  end

  def create
    @location = Location.where(:state => params[:state]).first
      if @location.nil?
        @location = Location.new(params.permit(:state, :kva_30_day, :kva_70_day, :kva_130_day, :kva_250_day, :kva_30_hour, :kva_70_hour, :kva_130_hour, :kva_250_hour))
      end
      @location.save
      render json: {}, status: 201 
    end

  def update
    @location = Location.find(params[:id])
     @location.update!(params.require(:location).permit(:kva_30_day, :kva_70_day, :kva_130_day, :kva_250_day, :kva_30_hour, :kva_70_hour, :kva_130_hour, :kva_250_hour))
  
        @location.save
        redirect_to '/locations',  :flash => {:notice => "Rate updated successfully"}
  
  end

    def location_params
      params.require(:location).permit(:kva_30_day, :kva_70_day, :kva_130_day, :kva_250_day, :kva_30_hour, :kva_70_hour, :kva_130_hour, :kva_250_hour)
    end

    def check_if_location_exists
    existing_location = Location.where(:state => params[:state]).first
      if existing_location.present?
        render json: "Location exists with this email", status: 500
        return
      end
    render json: {}, status: 201 
  end
end
