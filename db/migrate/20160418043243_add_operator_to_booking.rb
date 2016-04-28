class AddOperatorToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :operator_id, :integer 
  end
end
