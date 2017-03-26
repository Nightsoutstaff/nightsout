class Local < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  has_many :events, dependent: :destroy

  validates :user_id, presence: true
  validates :description, presence: true, length: { maximum: 1400 }
  validates :name, presence: true
  validates :category, presence: true
  validates :iva, presence: true
  validates :telephone, length: {minimum:9, maximum:11}
  
   
  mount_uploader :picture, PictureUploader
  validate  :picture_size

  geocoded_by :address
  # auto-fetch coordinates and the condition is for preventing fetching the same address more than once
  after_validation :geocode, if: :address_changed?

  def self.search_local(search)
    Local.near("%#{search}%", 5)
  end

  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
