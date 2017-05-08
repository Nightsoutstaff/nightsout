class Notification < ApplicationRecord
	belongs_to :user
	belongs_to :event
	belongs_to :local
	default_scope -> { order(created_at: :desc) }

	validates :user_id, presence: true
  	validates :text, presence: true, length: { maximum: 1900 }

end
