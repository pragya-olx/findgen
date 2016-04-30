class AddSubgroupToUser < ActiveRecord::Migration
  def change
    add_column :users, :subgroup_id, :integer
  end
end
