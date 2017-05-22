class ClientPagesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_role
  
  def all_events

    require 'date'
    require 'time'

    if not current_user.city.blank?||current_user.city == nil
      @city_user = current_user.city.split(',')[0].humanize
      @date = nil
      @category = nil
      @events_ids = []

      #Recupero i locali presenti nella città dell'utente
      @locals = Local.where(city: @city_user)

      if not @locals.empty?
        if (params[:search_date] == "" || params[:search_date] == nil) && (params[:search_category] == "" || params[:search_category] == nil) && (params[:order_category] == "" || params[:order_category] == nil || params[:order_category] == "Più recenti")
          @locals.each do |l|
            @events_ids += l.events.collect{|e| e.id }
          end
          @events = Event.where(:id => @events_ids).paginate(page: params[:page], :per_page => 10)
        else
          if params[:search_date] != nil
            @date = params[:search_date]
          end
          if params[:search_category] != nil
            @category = params[:search_category]
          end

          if @category != ""
            @locals.where({category: @category}).each do |l|
              if @date != ""
                @events_ids += l.events.where(start: (DateTime.strptime(@date, '%d-%m-%Y %H:%M'))-2.hours..(DateTime.strptime(@date, '%d-%m-%Y %H:%M')+1.day)).collect{|e| e.id }
              else
                @events_ids += l.events.collect{|e| e.id}
              end
            end
          else
            @locals.each do |l|
              if @date != ""
                @events_ids += l.events.where(start: (DateTime.strptime(@date, '%d-%m-%Y %H:%M'))-2.hours..(DateTime.strptime(@date, '%d-%m-%Y %H:%M')+1.day)).collect{|e| e.id }
              else
                @events_ids += l.events.collect{|e| e.id }
              end
            end
          end

          if params[:order_category] == "" || params[:order_category] == "Più recenti"
            @events = Event.where(:id => @events_ids).paginate(page: params[:page], :per_page => 10)
          elsif params[:order_category] == "Più popolari"
            @events = Event.where(:id => @events_ids).paginate(page: params[:page], :per_page => 10).reorder(followed_count: :desc)
          end
        end 
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

  private

  def check_role
    if not current_user.role == 'Cliente'
      if current_user.role == 'admin'
        redirect_to events_all_path
      elsif current_user.role == 'Gestore'
        redirect_to your_events_path
      elsif current_user.role == 'banned'
        redirect_to banned_path
      else
        redirect_to root_path
      end
    end
  end

end
