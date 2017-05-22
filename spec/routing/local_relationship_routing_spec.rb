require "rails_helper"

RSpec.describe "routes for local_relationships", :type => :routing do 

	it "create local_relationship" do
		expect(:post => "/local_relationships").to route_to(:controller=>"local_relationships",:action=>"create")
	end

	it "destroy local_relationship" do
		expect(:delete => "/local_relationships/1").to route_to(:controller=>"local_relationships",:action=>"destroy", :id=>"1")
	end

end