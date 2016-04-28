class AddInvoiceToBooking < ActiveRecord::Migration
  def change
    add_attachment :bookings, :invoice
  end
end
