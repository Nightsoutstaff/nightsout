class AdminPagesController < ApplicationController
  def events_all
  	@event = Event.all
  end

  def locals_all
  	@local = Local.all
  end

  def users_all
  	@user = User.all.paginate(page: params[:page], :per_page => 5)
  end

end
