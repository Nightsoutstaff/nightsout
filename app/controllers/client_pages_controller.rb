class ClientPagesController < ApplicationController
	before_action :authenticate_user!
	
  def all_events
    #@city = request.location.city
  end

  def following
    @user  ||= current_user
    @events = @user.following_event.paginate(page: params[:page], :per_page => 5)
    @locals = @user.following_local.paginate(page: params[:page], :per_page => 5)
  end

end
