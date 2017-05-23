class Event < ApplicationRecord
  belongs_to :local
  default_scope -> { order(created_at: :desc) }

  #has_many :following, through: :active_relationships, source: :followed_event
  #has_many :jobs, dependent: :destroy
  
  has_many :passive_event_relationships, class_name:  "EventRelationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy

  has_many :followers, through: :passive_event_relationships, source: :follower

  has_many :comments, as: :commentable, dependent: :destroy

  validates :local_id, presence: true
  default_scope -> { order(created_at: :desc) }

  validates :description, presence: true, length: { maximum: 1400 }
  validates :name, presence: true, :uniqueness => {:scope => [:local_id]}
  validates :start, presence: true
  validates :end, presence: true

  validate :start_before_end
   
  mount_uploader :picture, PictureUploader
  validate  :picture_size

  ratyrate_rateable "stars"

  def self.deleteEvents
    event = Event.joins(:local).where(['events.end<?', DateTime.now])
    if not event.blank?
        event.each do |e|
          EventRelationship.where(['followed_id=?', e.id]).each do |f|
            Notification.create(text: "Evento seguito scaduto!", additional_info: e.name, event_id: e.id, local_id: e.local_id, end: e.end, user_id: f.follower_id)
            Notification.where(text: "Evento in avvicinamento!", event_id: e.id).destroy_all
        end
        Notification.where(text: "Nuovo evento!", event_id: e.id).destroy_all
        Notification.create(text: "Evento scaduto!", additional_info: e.name, event_id: e.id, local_id: e.local_id, end: e.end, user_id: e.local.user_id)
        e.destroy
      end
    end
  end

  def self.approachingEvent
      near_events = Event.where(['start<?', DateTime.now+1.day])
      if not near_events.blank?
      near_events.each do |e|
        follower = e.followers
        if not follower.blank?
          follower.each do |n|
              if Notification.find_by(text: "Evento in avvicinamento!", event_id: e.id, user_id: n.id).blank?
                Notification.create(text: "Evento in avvicinamento!", event_id: e.id, end: e.start, user_id: n.id)
            end
          end
        end
      end
    end
  end


  def self.deleteFollowedEvents(idEvent, nameEvent)
    if not EventRelationship.where(followed_id: idEvent).blank?
      Notification.where(event_id: idEvent, text: "Evento in avvicinamento!").each do |n|
        n.update(text: "Evento in avvicinamento eliminato!", additional_info: nameEvent, read: false)
      end
      EventRelationship.where(followed_id: idEvent).each do |f|
        Notification.create(text: "Evento seguito eliminato!", additional_info: nameEvent, user_id: f.follower_id)
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

    def start_before_end
      if start != nil && self.end != nil && self.end < start
        errors.add(:start, ": fine evento prima del suo inizio")
      end
    end

end
