class EventRelationshipsController < ApplicationController
	before_action :authenticate_user!

  def create
    event = Event.find(params[:followed_id])
    current_user.follow_event(event)
    redirect_to following_path
  end

  def destroy
    event = EventRelationship.find(params[:id]).followed
    current_user.unfollow_event(event)
    redirect_to following_path
  end
end