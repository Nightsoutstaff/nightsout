class OwnerPagesController < ApplicationController
	before_action :authenticate_user!
  before_action :check_role

  def publish_events
  	@event = Event.new
  end

  def publish_locals
  	@local = current_user.locals.build
  end

  def your_events
  end

  def your_locals
  end

  private

  def check_role
    if not current_user.role == 'Gestore'
      if current_user.role == 'Cliente'
        redirect_to all_events_path
      elsif current_user.role == 'admin'
        redirect_to events_all_path
      elsif current_user.role == 'banned'
        redirect_to banned_path
      else
        redirect_to root_path
      end
    end
  end
  
end
