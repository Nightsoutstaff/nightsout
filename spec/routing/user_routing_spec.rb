require "rails_helper"

RSpec.describe "routes for users", :type => :routing do 

	it "following event" do
		expect(:get => "/users/1/following_event").to route_to(:controller=>"users",:action=>"following_event",id:"1")
	end

	it "following_local" do
		expect(:get => "/users/1/following_local").to route_to(:controller=>"users",:action=>"following_local",id:"1")
	end

	it "destroy user" do
		expect(:delete => "/users/1").to route_to(:controller=>"users",:action=>"destroy", :id=>"1")
	end

end