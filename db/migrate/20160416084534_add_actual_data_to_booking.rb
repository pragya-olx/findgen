class AddActualDataToBooking < ActiveRecord::Migration
  def change
  	add_column :bookings, :actual_days, :decimal
  	add_column :bookings, :actual_hours, :decimal
  end
end
