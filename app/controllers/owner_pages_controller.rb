class OwnerPagesController < ApplicationController
	before_action :authenticate_user!

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
  
end
