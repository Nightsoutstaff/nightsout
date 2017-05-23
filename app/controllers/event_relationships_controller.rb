class EventRelationshipsController < ApplicationController
	before_action :authenticate_user!

  def create
    event = Event.find(params[:followed_id])
    event.update_attributes(followed_count: event.followed_count + 1)
    current_user.follow_event(event)
    redirect_back(fallback_location: following_path)
  end

  def destroy
    event = EventRelationship.find(params[:id]).followed
    event.update_attributes(followed_count: event.followed_count - 1)
    current_user.unfollow_event(event)
    redirect_back(fallback_location: following_path)
  end
end