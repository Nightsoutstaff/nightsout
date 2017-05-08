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

  acts_as_commentable

  ratyrate_rateable "stars"

  def self.search_local(search)
    Local.near("%#{search}%", 5)
  end

  def self.deleteEvents
    event = Event.joins(:local).where(['events.end<?', DateTime.now])
    if not event.blank?
      event.each do |e|
        EventRelationship.where(['followed_id=?', e.id]).each do |f|
          Notification.create(text: "Evento seguito scaduto!", mentioned_by: "", event_id: e.id, local_: e.local_id, end: e.end, user_id: f.follower_id)
        end
        Notification.create(text: "Evento scaduto!", sent: true, event: e.name, local: e.local_id, end: e.end, user_id: e.local.user_id)
        e.destroy
      end
    end
  end

  #Caso in cui vado ad inserire all'interno del campo end della tabella notifiche, il contenuto del campo start dell'evento,
  #così da visualizzare la data dell'evento in arrivo. Questo metodo è inserito nello schedule.rb e verrà effettuato ogni 24h
  def self.approachingEvent
    if not Event.joins(:local).where(['events.start>?', DateTime.now+2]).blank?
      Event.joins(:local).where(['events.start>?', DateTime.now+2]).each do |e|
        EventRelationship.where(['followed_id=?', e.id]).each do |ee|
          Notification.create(text: "Evento in avvicinamento!", mentioned_by: "", event_id: e.id, local_id: "", end: e.start, user_id: ee.follower_id)
        end
      end
    end
  end

  def self.addFollowingLocalPublishEventNotification(idLocal, idEvent)
    if not LocalRelationship.where(followed_id: idLocal).blank?
      LocalRelationship.where(followed_id: idLocal).each do |l|
        Notification.create(text: "Nuovo evento!", mentioned_by: "", event_id: idEvent, local_id: idLocal, end: "", user_id: l.follower_id)
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
