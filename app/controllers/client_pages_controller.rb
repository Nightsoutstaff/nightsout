class ClientPagesController < ApplicationController
	before_action :authenticate_user!
	
  def all_events
  end

  def following
  end

  def event_page
  end

  def local_page
  end
end
