class AdminPagesController < ApplicationController
  def events_all
  	@events = Event.all.paginate(page: params[:page], :per_page => 10)
  end

  def locals_all
  	@locals = Local.all.paginate(page: params[:page], :per_page => 10)
  end

  def users_all
  	@users = User.where.not(role:'admin').paginate(page: params[:page], :per_page => 10)
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
