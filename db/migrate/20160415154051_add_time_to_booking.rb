class AddTimeToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :time_in, :string
    add_column :bookings, :time_out, :string
  end
end



