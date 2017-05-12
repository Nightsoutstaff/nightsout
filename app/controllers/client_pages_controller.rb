class ClientPagesController < ApplicationController
  before_action :authenticate_user!
  
  def all_events

    require 'date'
    require 'time'

    #@city = request.location.city
    if current_user.city.blank?||current_user.city == nil
      @erroreCitta = 1
    else
      @city_user = current_user.city.split(',')[0].humanize
      @date = nil
      @category = nil
      @events_ids = []

      #Recupero i locali presenti nella città dell'utente
      @locals = Local.where(city: @city_user)

      if @locals.empty?
        @erroreCitta = 1
      end

      if (params[:search_date] == "" || params[:search_date] == nil) && (params[:search_category] == "" || params[:search_category] == nil) && (params[:order_category] == "" || params[:order_category] == nil || params[:order_category] == "Più recenti")
          @locals.each do |l|
            @events_ids += l.events.collect{|e| e.id }
          end
        @events = Event.where(:id => @events_ids).paginate(page: params[:page], :per_page => 10)

      elsif params[:order_category] == "" || params[:order_category] == "Più recenti"

        if params[:search_date] != nil
          @date = params[:search_date]
        end

        if params[:search_category] != nil
          @category = params[:search_category]
        end

        if @category != ""
          @locals.where({category: @category}).each do |l|
            if @date != ""
              @events_ids += l.events.where(start: (DateTime.strptime(@date, '%d-%m-%Y %H:%M'))..(DateTime.strptime(@date, '%d-%m-%Y %H:%M')+1.day)).collect{|e| e.id }
            else
              @events_ids += l.events.collect{|e| e.id}
            end
          end
        else
          @locals.each do |l|
            if @date != ""
              @events_ids += l.events.where(start: (DateTime.strptime(@date, '%d-%m-%Y %H:%M'))..(DateTime.strptime(@date, '%d-%m-%Y %H:%M')+1.day)).collect{|e| e.id }
            else
              @events_ids += l.events.collect{|e| e.id }
            end
          end
        end

        @events = Event.where(:id => @events_ids).paginate(page: params[:page], :per_page => 10)

      elsif params[:order_category] == "Più popolari"
        
        if params[:search_date] != nil
          @date = params[:search_date]
        end

        if params[:search_category] != nil
          @category = params[:search_category]
        end

        if @category != ""
          @locals.where({category: @category}).each do |l|
            if @date != ""
              @events_ids += l.events.where(start: (DateTime.strptime(@date, '%d-%m-%Y %H:%M'))..(DateTime.strptime(@date, '%d-%m-%Y %H:%M')+1.day)).collect{|e| e.id }
            else
              @events_ids += l.events.collect{|e| e.id}
            end
          end
        else
          @locals.each do |l|
            if @date != ""
              @events_ids += l.events.where(start: (DateTime.strptime(@date, '%d-%m-%Y %H:%M'))..(DateTime.strptime(@date, '%d-%m-%Y %H:%M')+1.day)).collect{|e| e.id }
            else
              @events_ids += l.events.collect{|e| e.id }
            end
          end
        end

        @events = Event.where(:id => @events_ids).paginate(page: params[:page], :per_page => 10).reorder(followed_count: :desc)
      end

    end
  end

  def following
    @user  ||= current_user
    @locals = @user.following_local.paginate(page: params[:page], :per_page => 5)
    #@locals.each do |l|
      #l.events.each do |e|
        #if @user.following_event?(e)
        #else @user.following_event << e
        #end
      #end
    #end
    @events = @user.following_event.paginate(page: params[:page], :per_page => 5)
  end

end
