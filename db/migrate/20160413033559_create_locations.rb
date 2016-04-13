class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|

      t.string :state
      t.string :city
      t.string :kv
      t.integer :fixed, default: 0
      t.integer :variable, default: 0

      t.timestamps null: false
    end
  end
end
