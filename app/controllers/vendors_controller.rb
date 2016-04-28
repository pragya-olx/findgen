class VendorsController < ApplicationController

  def index
    @vendors = User.where(:role_type => "vendor")
    @states = CS.states(:IN)
    respond_to do |format|
      format.json {render :json => User.where(:role_type => "vendor"), :status => 200}
      format.html
    end
  end

end
