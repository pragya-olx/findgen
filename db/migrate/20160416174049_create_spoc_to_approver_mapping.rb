class CreateSpocToApproverMapping < ActiveRecord::Migration
  def change
    create_table :spoc_to_approver_mappings do |t|
      t.integer :spoc_id
      t.integer :approver1_id
      t.integer :approver2_id

      t.timestamps
    end
  end
end
