class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start
      t.datetime :end
      t.text :description
      t.references :local, foreign_key: true

      t.timestamps
    end
    add_index :events, [:local_id, :created_at]
  end
end
