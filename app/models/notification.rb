class Notification < ApplicationRecord
	belongs_to :user
	belongs_to :event, optional: true
	belongs_to :local, optional: true
	belongs_to :comment, optional: true
	
	default_scope -> { order(created_at: :desc) }

	validates :user_id, presence: true
  	validates :text, presence: true, length: { maximum: 1900 }

end
