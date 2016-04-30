class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :client_id
      t.integer :user_id
      t.string :name

      t.timestamps null: false
    end
  end
end
