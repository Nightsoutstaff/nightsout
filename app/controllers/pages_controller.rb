class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:notifications]

  def notifications
    @oldNotifications = nil
    @newNotifications = nil
    @oldNotifications = Notification.where(['user_id = ? AND read = ?', current_user.id, true])
    @newNotifications = Notification.where(['user_id = ? AND read = ?', current_user.id, false])
    if(@oldNotifications.count > 10)
      Notification.delete(['user_id=? AND id=?', current_user.id, @oldNotifications.last.id])
    end
  end

  def home
  end

  def help
  end

  def about
  end

  def contact
  end

  def banned
  end

  def search
    require 'date'
    require 'time'

    @locals = nil
    @address = nil
    @category = nil
    @positions = []
    @empty_positions = []
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
        @empty_locals_ids = []
        if params[:also_empty] == 'yes'
          @locals.each do |l|
            if l.events.empty?
              @empty_locals_ids << l.id
            end
          end
          @empty_locals = Local.where(:id => @empty_locals_ids).paginate(page: params[:page], :per_page => 5)
          @empty_locals.each do |l|
            (@empty_positions ||= []) << [l.latitude, l.longitude, l.name, l.id, l.address]
          end
        end 

        @events_ids = []
        if @category != '' 
          @locals.where({category: @category}).each do |l|
            if @date != ''
              @events_ids += l.events.where(start: (DateTime.strptime(@date, '%d-%m-%Y %H:%M'))-2.hours..(DateTime.strptime(@date, '%d-%m-%Y %H:%M')+1.day)).collect{|e| e.id }
            else
              @events_ids += l.events.collect{|e| e.id}
            end
          end
        else
          @locals.each do |l|
            if @date != ''
              @events_ids += l.events.where(start: (DateTime.strptime(@date, '%d-%m-%Y %H:%M'))-2.hours..(DateTime.strptime(@date, '%d-%m-%Y %H:%M')+1.day)).collect{|e| e.id }
            else
              @events_ids += l.events.collect{|e| e.id }
            end
          end
        end

        @events = Event.where(:id => @events_ids).paginate(page: params[:page], :per_page => 5)
        @events.each do |e|
          (@positions ||= []) << [e.local.latitude, e.local.longitude, e.name, e.local.address, e.id, e.local.name, e.local.id]
        end 
      end 
    end
  end

end
