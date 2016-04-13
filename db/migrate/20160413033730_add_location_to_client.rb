class AddLocationToClient < ActiveRecord::Migration
  def change
    add_reference :clients, :location
  end
end
