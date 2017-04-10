class LocalRelationshipsController < ApplicationController
	before_action :authenticate_user!

  def create
    local = Local.find(params[:followed_id])
    current_user.follow_local(local)
    redirect_to following_path
  end

  def destroy
    local = LocalRelationship.find(params[:id]).followed
    current_user.unfollow_local(local)
    redirect_to following_path
  end
end