class CreateCustomItems < ActiveRecord::Migration
  def change
    create_table :custom_items do |t|
      t.string :name
      t.string :included_acc
      t.integer :quantity
      t.string :remark
      t.float :price
      t.integer :project_id
      t.integer :category_id

      t.timestamps
    end
  end
end
