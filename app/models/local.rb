class Local < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  has_many :events, dependent: :destroy
  #has_many :following, through: :active_relationships, source: :followed_local

  has_many :passive_local_relationships, class_name:  "LocalRelationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy

  has_many :followers, through: :passive_local_relationships, source: :follower

  validates :user_id, presence: true
  validates :description, presence: true, length: { maximum: 1400 }
  validates :name, presence: true
  validates :category, presence: true
  validates :iva, presence: true
  validates :telephone, length: {minimum:8, maximum:11}
   
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

  def self.search_local(search)
    Local.near("%#{search}%", 5)
  end

  def self.deleteEvents
    event = Event.joins(:local).where(['events.end<?', DateTime.now])
    if not event.blank?
      for i in 0..event.size-1
        followerEvent = EventRelationship.where(['followed_id=?', event[i].id])
          for k in 0..followerEvent.size-1
            Notification.create(text: "Evento seguito scaduto!", sent: true, event: event[i].name, local: event[i].local_id, end: event[i].end, user_id: followerEvent[k].follower_id)
          end
          Notification.create(text: "Evento scaduto!", sent: true, event: event[i].name, local: event[i].local_id, end: event[i].end, user_id: event[i].local.user_id)
          event[i].destroy
      end
    end
  end

  #Caso in cui vado ad inserire all'interno del campo end della tabella notifiche, il contenuto del campo start dell'evento,
  #così da visualizzare la data dell'evento in arrivo. Questo metodo è inserito nello schedule.rb e verrà effettuato ogni 24h
  def self.approachingEvent
    event = Event.joins(:local).where(['events.start>?', DateTime.now+2])
    if not event.blank?
      for i in 0..event.size-1
        followerEvent = EventRelationship.where(['followed_id=?', event[i].id])
          for k in 0..followerEvent.size-1
            Notification.create(text: "Evento in avvicinamento!", sent: true, event: event[i].name, local: "", end: event[i].start, user_id: followerEvent[k].follower_id)
          end
      end
    end
  end

  def self.addFollowingLocalPublishEventNotification(idLocal, nameLocal)
    local = LocalRelationship.where(followed_id: idLocal)
    if not local.blank?
      for i in 0..local.size-1
         Notification.create(text: "Nuovo evento!", sent: true, event: "", local: nameLocal, end: "", user_id: local[i].follower_id)
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

end
