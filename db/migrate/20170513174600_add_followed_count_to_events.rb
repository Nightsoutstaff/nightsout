class AddFollowedCountToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :followed_count, :integer, default: 0
  end
end
