class CreateOperators < ActiveRecord::Migration
  def change
    create_table :operators do |t|
    	t.string :name
    	t.string :phone_number
    	t.string :email
    	t.integer :vendor_id

        t.timestamps
    end
  end
end
