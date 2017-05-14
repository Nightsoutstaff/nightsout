class AddLikesToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :likes, :integer, default: 0
  end
end
