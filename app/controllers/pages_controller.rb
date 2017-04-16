class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:notifications]

  def notifications
    @oldNotifications = nil
    @newNotifications = nil
    @oldNotifications = Notification.where(['user_id = ? AND read = ?', current_user.id, true]).paginate(page: params[:page], :per_page => 5)
    @newNotifications = Notification.where(['user_id = ? AND read = ?', current_user.id, false]).paginate(page: params[:page], :per_page => 5)
  end

  def home
  end

  def help
  end

  def about
  end

  def contact
  end

  def search
    require 'date'
    require 'time'

    @locals = nil
    @address = nil
    @category = nil
    @positions = []
    @lat = 0
    @lng = 0
    @date = nil
    if params[:search] != nil && params[:search].length > 1
      @address = params[:search]
      @locals = Local.search_local(@address).order("created_at DESC")
      @lat = Geocoder.coordinates(@address)[0]
      @lng = Geocoder.coordinates(@address)[1]
      if params[:search_category] != nil
        @category = params[:search_category]
      end
      if params[:search_date] != nil
        @date = params[:search_date]
      end
    
      if not @locals.blank?
        @events_ids = []
        if @category != '' 
          @locals.where({category: @category}).each do |l|
            if @date != ''
              @events_ids += l.events.where(start: (DateTime.strptime(@date, '%d-%m-%Y %H:%M'))..(DateTime.strptime(@date, '%d-%m-%Y %H:%M')+1.day)).collect{|e| e.id }
            else
              @events_ids += l.events.collect{|e| e.id}
            end
          end
        else
          @locals.each do |l|
            if @date != ''
              @events_ids += l.events.where(start: (DateTime.strptime(@date, '%d-%m-%Y %H:%M'))..(DateTime.strptime(@date, '%d-%m-%Y %H:%M')+1.day)).collect{|e| e.id }
            else
              @events_ids += l.events.collect{|e| e.id }
            end
          end
        end

        @events = Event.where(:id => @events_ids).paginate(page: params[:page], :per_page => 5)
        @events.each do |e|
          (@positions ||= []) << [e.local.latitude, e.local.longitude, e.name, e.description]
        end 
      end 
    end
  end

end
