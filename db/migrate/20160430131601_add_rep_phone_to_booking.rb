class AddRepPhoneToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :rep_phone_number, :string
  end
end
