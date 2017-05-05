class User < ApplicationRecord

  has_many :locals, dependent: :destroy
  #Aggiunta la riga delle notifiche
  has_many :notifications, dependent: :destroy

  has_many :active_event_relationships, class_name:  "EventRelationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :active_local_relationships, class_name:  "LocalRelationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy

  has_many :following_local, through: :active_local_relationships, source: :followed
  has_many :following_event, through: :active_event_relationships, source: :followed

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  acts_as_commontator
  #acts_as_voter


  def self.from_omniauth(auth)#, f)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0,20]
      #f[:notice]="questa è la tua password per modificare il tuo account: "+"'"+user.password+"' "+"questo messaggio non verrà più mostrato quindi bisogna salvarsi questa password"
      #user.skip_confirmation!
    end
	end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
		end 
	end

  ROLES = %i[client owner]  # + admin e banned non a scelta dell'utente

  # Follows an event.
  def follow_event(event)
    following_event << event
  end

  # Unfollows an event.
  def unfollow_event(event)
    following_event.delete(event)
  end

  # Returns true if the current user is following the event.
  def following_event?(event)
    following_event.include?(event)
  end

  # Follows a local.
  def follow_local(local)
    following_local << local
    local.events.each do |e|
      if following_event?(e)
      else following_event << e
      end
    end
  end

  # Unfollows a local.
  def unfollow_local(local)
    following_local.delete(local)
  end

  # Returns true if the current user is following the local.
  def following_local?(local)
    following_local.include?(local)
  end

end
