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
		@lisp = Lisp.find(params[:id])
	end

	def update
		@lisp = Lisp.find(params[:id])
		@lisp.update!(lisp_params)
		redirect_to '/lisps'
	end

	def lisp_params
		params.require(:lisp).permit(:name, :state, :city, :address, :zone, :code)
	end
end
