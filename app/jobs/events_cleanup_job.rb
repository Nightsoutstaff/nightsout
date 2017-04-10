class EventsCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    
	# Enqueue a job to be performed tomorrow at noon.
	# EventsCleanupJob.set(wait_until: Date.tomorrow.noon).perform_later(event)
  end
end
