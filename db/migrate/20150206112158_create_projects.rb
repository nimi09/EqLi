class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.string :production
      t.string :dop
      t.datetime :pickupday
      t.datetime :returnday
      t.integer :shootingdays
      t.integer :creator_id

      t.timestamps
    end
    add_index :projects, [:creator_id, :created_at]
  end
end
