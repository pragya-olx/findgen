class AddSlipToBooking < ActiveRecord::Migration
  def change
  	add_column :bookings, :slip, :string
  end
end
