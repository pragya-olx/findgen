class CreateBookingUpdates < ActiveRecord::Migration
  def change
    create_table :booking_updates do |t|
    	t.integer :booking_id
    	t.integer :user_id
    	t.string :from_status
    	t.string :to_status

    	t.timestamps
    end
  end
end
