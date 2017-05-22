class Local < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  has_many :events, dependent: :destroy
  #has_many :following, through: :active_relationships, source: :followed_local

  has_many :passive_local_relationships, class_name:  "LocalRelationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy

  has_many :followers, through: :passive_local_relationships, source: :follower
  
  has_many :comments, as: :commentable, dependent: :destroy

  validates :user_id, presence: true
  validates :description, presence: true, length: { maximum: 1400 }
  validates :name, presence: true
  validates :category, presence: true
  validates :iva, presence: true, uniqueness: true
  validate :check_IVA
  validates :telephone, length: {minimum:8, maximum:11}
  validates :address, presence: true
   
  mount_uploader :picture, PictureUploader
  validate  :picture_size

  geocoded_by :address
  # auto-fetch coordinates and the condition is for preventing fetching the same address more than once
  after_validation :geocode, if: :address_changed?

  reverse_geocoded_by :latitude, :longitude do |obj,results|
  if geo = results.first
    obj.city    = geo.city
    end
  end
  after_validation :reverse_geocode

  ratyrate_rateable "stars"

  def self.search_local(search)
    Local.near("%#{search}%", 5)
  end

  #Caso in cui vado ad inserire all'interno del campo end della tabella notifiche, il contenuto del campo start dell'evento,
  #così da visualizzare la data dell'evento in arrivo. Questo metodo è inserito nello schedule.rb e verrà effettuato ogni 24h

  def self.addFollowingLocalPublishEventNotification(idLocal, idEvent, nameEvent)
    if not LocalRelationship.where(followed_id: idLocal).blank?
      LocalRelationship.where(followed_id: idLocal).each do |l|
        Notification.create(text: "Nuovo evento!", additional_info: nameEvent, event_id: idEvent, local_id: idLocal, end: "", user_id: l.follower_id)
      end
    end   
  end

  def self.deleteFollowingLocal(idLocal, nameLocal)
    if not LocalRelationship.where(followed_id: idLocal).blank?
      Notification.where(text: "Nuovo evento!", local_id: idLocal).each do |n|
        n.update(text: "Evento locale seguito eliminato!", read: false)
      end
      LocalRelationship.where(followed_id: idLocal).each do |l|
        Notification.create(text: "Locale seguito eliminato!", additional_info: nameLocal, local_id: idLocal, end: "", user_id: l.follower_id)
      end
    end   
  end


  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

    def check_IVA
      temp = iva
      iva_array = []
      while temp >0
        iva_array << temp%10
        temp /= 10
      end
      iva_array.reverse
      if iva_array.length < 11
        errors.add(:iva, "Partita IVA troppo corta")
      elsif iva_array.length > 11
        errors.add(:iva, "Partita IVA troppo lunga")
      else
        x = iva_array[0] + iva_array[2] + iva_array[4] + iva_array[6] + iva_array[8] + iva_array[10]
        y1 = 2*iva_array[1]
        y1-=9 if y1>9 
        y2 = 2*iva_array[3]
        y2-=9 if y2>9 
        y3 = 2*iva_array[5]
        y3-=9 if y3>9 
        y4 = 2*iva_array[7]
        y4-=9 if y4>9 
        y5 = 2*iva_array[9] 
        y5-=9 if y5>9 
        y = y1 + y2 + y3 + y4 + y5
        if (x+y)%10 != 0
          errors.add(:iva,"Partita IVA non valida")
        end
      end
    end

end
