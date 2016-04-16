class AddCostToBooking < ActiveRecord::Migration
  def change
  	add_column :bookings, :cost, :decimal
  end
end
