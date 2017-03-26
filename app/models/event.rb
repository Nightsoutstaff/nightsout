class Event < ApplicationRecord
  belongs_to :local
  validates :local_id, presence: true
  default_scope -> { order(created_at: :desc) }

  validates :description, presence: true, length: { maximum: 1400 }
  validates :name, presence: true
  validates :start, presence: true
  validates :end, presence: true
   
  mount_uploader :picture, PictureUploader
  validate  :picture_size

  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
