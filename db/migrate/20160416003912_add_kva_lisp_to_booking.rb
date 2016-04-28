class AddKvaLispToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :lisp, :string
    add_column :bookings, :kva, :string
  end
end
