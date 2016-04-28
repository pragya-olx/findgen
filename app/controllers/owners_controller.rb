class OwnersController < ApplicationController

  def index
    @owners = User.where(:role_type => "owner")
    respond_to do |format|
      format.json {render :json => User.where(:role_type => "owner"), :status => 200}
      format.html
    end
  end
end
