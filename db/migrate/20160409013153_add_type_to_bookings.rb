class AddTypeToBookings < ActiveRecord::Migration
  def change
  	add_column :bookings, :gen_type, :string
  end
end
