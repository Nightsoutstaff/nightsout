class CreateLocals < ActiveRecord::Migration[5.0]
  def change
    create_table :locals do |t|
      t.string :name
      t.string :category
      t.text :description
      t.integer :telephone, :limit => 8
      t.string :address
      t.string :website
      t.integer :iva, :limit => 8
      t.string :city
      t.float :latitude
      t.float :longitude
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :locals, [:user_id, :created_at]
  end
end
