require 'rails_helper'

RSpec.describe LocalRelationshipsController, type: :controller do

	before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.create(id: 1, :email => 'test1@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'Gestore')
   	sign_in @user
   	@local = Local.create(id:2, user_id:2, name:"locale2",address:"via Tuscolana,RM", description: "boh", picture: nil, website: "www.ciao.it", telephone: "1234567890", iva: "11005760159", category:"Pub")
  end

  describe "POST #create" do	
	  it "segui locale" do
		  expect{
	     	post :create, params: {id:1, follower_id: 1, followed_id: 2}
		 	}.to change(LocalRelationship, :count).by(1)

		 	expect(response).to redirect_to(following_path)
	  end
  end

  describe "POST #destroy" do
		it "smetti di seguire locale" do
			@relationship = LocalRelationship.create(id:1, follower_id: 1, followed_id: 2)
			expect{ 
	      delete :destroy, params: {:id => @relationship}
	    }.to change(LocalRelationship, :count).by(-1)
	  	
	  	expect(response).to redirect_to(following_path)
  	end
  end

end