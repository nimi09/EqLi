class CreateAssignedProducts < ActiveRecord::Migration
  def change
    create_table :assigned_products do |t|
      t.integer :quantity
      t.string :remarks
      t.integer :project_id
      t.integer :product_id

      t.timestamps
    end
  end
end
