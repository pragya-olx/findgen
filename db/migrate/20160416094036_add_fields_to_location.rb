class AddFieldsToLocation < ActiveRecord::Migration
  def change
  	add_column :locations, :kva_30_day, :decimal
  	add_column :locations, :kva_30_hour, :decimal
  	add_column :locations, :kva_70_day, :decimal
  	add_column :locations, :kva_70_hour, :decimal
  	add_column :locations, :kva_130_day, :decimal
  	add_column :locations, :kva_130_hour, :decimal
  	add_column :locations, :kva_250_day, :decimal
  	add_column :locations, :kva_250_hour, :decimal
  end
end
