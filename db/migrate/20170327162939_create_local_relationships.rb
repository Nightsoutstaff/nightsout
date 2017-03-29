class CreateLocalRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :local_relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :local_relationships, :follower_id
    add_index :local_relationships, :followed_id
    add_index :local_relationships, [:follower_id, :followed_id], unique: true
  end
end
