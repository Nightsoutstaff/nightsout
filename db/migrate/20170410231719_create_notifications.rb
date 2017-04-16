class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
    	t.string :text
    	t.boolean :read, default: false
    	t.boolean :sent, default: false
    	t.string :event
      t.string :local
    	t.datetime :end

    	t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :notifications, [:user_id, :created_at]
  end
end
