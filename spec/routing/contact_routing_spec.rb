require "rails_helper"

RSpec.describe "routes for contacts", :type => :routing do 

	it "create contact" do
		expect(:post => "/contacts").to route_to(:controller=>"contacts",:action=>"create")
	end


end