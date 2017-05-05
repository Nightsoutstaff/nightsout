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

  def ban
  	@user = User.find(params[:id])
  	@user.update_attributes(:role => 'banned')
  	redirect_to users_all_path
  end

  def unban
  	@user = User.find(params[:id])
  	@user.update_attributes(:role => 'client')
  	redirect_to users_all_path
  end

end
