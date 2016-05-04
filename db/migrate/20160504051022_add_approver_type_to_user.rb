class AddApproverTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :approver_type, :string
  end
end
