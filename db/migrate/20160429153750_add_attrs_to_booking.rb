class AddAttrsToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :assessment, :string
    add_column :bookings, :spoc_remarks, :string
    add_column :bookings, :owner_remarks, :string
    add_column :bookings, :invoice_status, :string
    add_column :bookings, :hours_status, :string
  end
end
