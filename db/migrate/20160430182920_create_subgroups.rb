class CreateSubgroups < ActiveRecord::Migration
  def change
    create_table :subgroups do |t|
      t.integer :group_id
      t.integer :client_id
      t.string :name
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
