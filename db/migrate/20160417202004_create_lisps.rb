class CreateLisps < ActiveRecord::Migration
  def change
    create_table :lisps do |t|
      t.string :state
      t.string :city
      t.string :zone
      t.string :name
      t.string :address
      t.string :code

        t.timestamps
    end

    add_index :lisps, :code
  end
end
