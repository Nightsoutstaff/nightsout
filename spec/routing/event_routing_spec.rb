require "rails_helper"

RSpec.describe "routes for events", :type => :routing do 

	it "show event" do
		expect(:get => "/events/1").to route_to(:controller=>"events",:action=>"show",:id=>"1")
	end

	it "create event" do
		expect(:post => "/events").to route_to(:controller=>"events",:action=>"create")
	end

	it "destroy event" do
		expect(:delete => "/events/1").to route_to(:controller=>"events",:action=>"destroy", :id=>"1")
	end

	it "edit event" do
		expect(:get => "/events/1/edit").to route_to(:controller=>"events",:action=>"edit",:id=>"1")
	end

	it "update event" do
		expect(:put => "/events/1").to route_to(:controller=>"events",:action=>"update",:id=>"1")
	end

	it "followers" do
		expect(:get => "/events/1/followers").to route_to(:controller=>"events",:action=>"followers",:id=>"1")
	end

end