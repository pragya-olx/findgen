class LispsController < ApplicationController

  def index
    @lisps = Lisp.all
    @states = CS.states(:IN)
  end

  def create
      @lisp = Lisp.create(lisp_params)
      render json: {}, status: 201 
  end

  def show
    if params[:id] != 'unknown'
      @lisp = Lisp.find(params[:id])
    else
      @lisp = Lisp.find_by_code(params[:code])
      if @lisp.nil?
        redirect_to '/lisps'
      end
    end
  end

  def update
    @lisp = Lisp.find(params[:id])
    @lisp.update!(lisp_params)
    redirect_to '/lisps', , :flash => {:notice => "Successfully updated LISP"}
  end

  def lisp_params
    params.require(:lisp).permit(:name, :state, :city, :address, :zone, :code)
  end
end
