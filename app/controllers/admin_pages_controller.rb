class AdminPagesController < ApplicationController
  def events_all
    if params[:search_event] != nil 
      @events = Event.where(name: params[:search_event]).paginate(page: params[:page], :per_page => 10)
    else
      @events = Event.all.paginate(page: params[:page], :per_page => 10)
    end
  end

  def locals_all
    if params[:search_local] != nil
      @locals = Local.where(name: params[:search_local]).paginate(page: params[:page], :per_page => 10)
    else
      @locals = Local.all.paginate(page: params[:page], :per_page => 10)
    end
  end

  def users_all
    if params[:search_user] != nil 
      @users = User.where(name: params[:search_user]).paginate(page: params[:page], :per_page => 10)
    else
      @users = User.where.not(role:'admin').paginate(page: params[:page], :per_page => 10)
    end
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
