require "rails_helper"

RSpec.describe "routes for event_relationships", :type => :routing do 

	it "create event_relationship" do
		expect(:post => "/event_relationships").to route_to(:controller=>"event_relationships",:action=>"create")
	end

	it "destroy event_relationship" do
		expect(:delete => "/event_relationships/1").to route_to(:controller=>"event_relationships",:action=>"destroy", :id=>"1")
	end

end