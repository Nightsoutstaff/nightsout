require "rails_helper"

RSpec.describe "routes for localss", :type => :routing do 

	it "show local" do
		expect(:get => "/locals/1").to route_to(:controller=>"locals",:action=>"show",:id=>"1")
	end

	it "create local" do
		expect(:post => "/locals").to route_to(:controller=>"locals",:action=>"create")
	end

	it "destroy local" do
		expect(:delete => "/locals/1").to route_to(:controller=>"locals",:action=>"destroy", :id=>"1")
	end

	it "edit local" do
		expect(:get => "/locals/1/edit").to route_to(:controller=>"locals",:action=>"edit",:id=>"1")
	end

	it "update local" do
		expect(:put => "/locals/1").to route_to(:controller=>"locals",:action=>"update",:id=>"1")
	end

	it "followers" do
		expect(:get => "/locals/1/followers").to route_to(:controller=>"locals",:action=>"followers",:id=>"1")
	end

end