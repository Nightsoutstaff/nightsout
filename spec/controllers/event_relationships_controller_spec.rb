require 'rails_helper'

RSpec.describe EventRelationshipsController, type: :controller do

	before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.create(id: 1, :email => 'test1@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'Gestore')
   	sign_in @user
   	@local = Local.create(id:1, user_id:1, name:"locale1",address:"via Tuscolana,RM", description: "boh", picture: nil, website: "www.ciao.it", telephone: "1234567890", iva: "13904601005", category:"Pub")  
   	@event = Event.create(id:2, name: "evento",description: "cose varie",local_id:@local.id, start:"2017-05-14 17:04:00", end: "2017-05-16 19:05:00", picture: nil)
	end

  describe "POST #create" do	
	  it "segui evento (redirect a pagina seguiti)" do
	  	expect{
	     	post :create, params: {id:1, follower_id: 1, followed_id: 2}
		 	}.to change(EventRelationship, :count).by(1)

		 	expect(response).to redirect_to(following_path)
	  end

	  it "segui evento (redirect back su pagina evento)" do
	  	@request.env['HTTP_REFERER'] = 'http://test.host/events/2'
		  expect{
	     	post :create, params: {id:1, follower_id: 1, followed_id: 2}
		 	}.to change(EventRelationship, :count).by(1)

		 	expect(response).to redirect_to(@event)
	  end
  end

  describe "POST #destroy" do
		it "smetti di seguire evento (redirect a pagina seguiti)" do
			@relationship = EventRelationship.create(id:1, follower_id: 1, followed_id: 2)
			expect{ 
	      delete :destroy, params: {:id => @relationship}
	    }.to change(EventRelationship, :count).by(-1)
	  	
	  	expect(response).to redirect_to(following_path)
  	end

  	it "smetti di seguire evento (redirect back su pagina evento" do
			@request.env['HTTP_REFERER'] = 'http://test.host/events/2'
			@relationship = EventRelationship.create(id:1, follower_id: 1, followed_id: 2)
			expect{ 
	      delete :destroy, params: {:id => @relationship}
	    }.to change(EventRelationship, :count).by(-1)
	  	
	  	expect(response).to redirect_to(@event)
  	end
  end

end