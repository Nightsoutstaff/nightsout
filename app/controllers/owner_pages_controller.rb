class OwnerPagesController < ApplicationController
	before_action :authenticate_user!

  def publish_events
  end

  def publish_locals
  end
end
