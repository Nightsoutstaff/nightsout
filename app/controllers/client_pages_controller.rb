class ClientPagesController < ApplicationController
	before_action :authenticate_user!
	
  def all_events

    require 'date'
    require 'time'

    #@city = request.location.city
    @city_user = current_user.city.split(',')[0].humanize
    @date = nil
    @category = nil
    @events_ids = []

    @locals = Local.where(city: @city_user)

    if params[:search_date] == nil && params[:search_category] == nil
      if not @locals.empty?
          @locals.each do |l|
            @events_ids += l.events.collect{|e| e.id }
          end
        @events = Event.where(:id => @events_ids).paginate(page: params[:page], :per_page => 10)
      else
        @erroreCitta = 1
      end
    else

      if params[:search_category] != nil
        @category = params[:search_category]
      end
      if params[:search_date] != nil
        @date = params[:search_date]
      end

      if not @locals.empty?
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
          @events = Event.where(:id => @events_ids).paginate(page: params[:page], :per_page => 10)
      else
        @erroreCitta = 1
      end
    end
  end

  def following
    @user  ||= current_user
    @events = @user.following_event.paginate(page: params[:page], :per_page => 5)
    @locals = @user.following_local.paginate(page: params[:page], :per_page => 5)
  end

end
