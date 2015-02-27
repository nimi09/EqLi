class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :included_acc
      t.string :thumb_url
      t.integer :category_id

      t.timestamps
    end
  end
end
