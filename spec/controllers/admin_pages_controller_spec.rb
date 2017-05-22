require 'rails_helper'

RSpec.describe AdminPagesController, type: :controller do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @admin = User.create(id: 1, :email => 'test1@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'admin')
   	sign_in @admin
  end

  describe "POST #ban" do

  	let(:new_role_ban) {{role: 'banned'}}

  	it "banna utente" do
  		@request.env["devise.mapping"] = Devise.mappings[:user]
    	@user = User.create(id: 2, :email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'Cliente')
   	
  		put :ban, params: {:id => @user, :user => new_role_ban}
      @user.reload
      expect(@user.role).to eq('banned')
  		expect(response).to redirect_to(users_all_path)
  	end
  end

  describe "POST #unban" do

  	let(:new_role_unban) {{role: 'Cliente'}}

  	it "unbanna utente" do
  		@request.env["devise.mapping"] = Devise.mappings[:user_banned]
    	@user_banned = User.create(id: 3, :email => 'test3@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'banned')
   	
  		put :unban, params: {:id => @user_banned, :user => new_role_unban}
      @user_banned.reload
      expect(@user_banned.role).to eq('Cliente')
  		expect(response).to redirect_to(users_all_path)
  	end
  end

end