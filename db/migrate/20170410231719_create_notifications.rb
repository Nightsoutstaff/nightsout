class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
    	t.string :text
      t.string :mentioned_by
    	t.boolean :read, default: false
    	t.datetime :end

    	t.references :user, foreign_key: true
      t.references :event
      t.references :local

      t.timestamps
    end
    add_index :notifications, [:user_id, :created_at]
  end
end
