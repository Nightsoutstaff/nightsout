class OwnerPagesController < ApplicationController
	before_action :authenticate_user!

  def publish_events
  	#@local= Local.find_by(params[:local_id])
    @event = Event.new #@local.events.build
  end

  def publish_locals
  	@local = current_user.locals.build
  end

  def your_events
    require 'date'
    require 'time'
    @events_del = []
    current_user.locals.each do |l|
      if l.events.any?
        #SELECT id FROM eventi WHERE cond (La collect sarebbe la select)
        @events_del += l.events.where("end<?", DateTime.now).collect{|e| e.id }
        if not @events_del.blank?
          @event_d = Event.where(:id => @events_del).destroy_all
          flash[:success] = "Evento eliminato perchè scaduto!"
          redirect_to  your_events_path
        end
      end
    end
  end

  def your_locals
  end
  
end
