require 'rails_helper'

RSpec.describe UsersController, type: :controller do

	before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.create(:email => 'test1@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'Cliente')
   	sign_in @user
  end

  it "esiste current_user dopo login" do
    expect(subject.current_user).to_not eq(nil)
  end

  it "non esiste current_user dopo logout" do
  	sign_out @user
    expect(subject.current_user).to eq(nil)
  end

  it "elimina account" do
  	expect{ 
      delete :destroy, params: {:id => @user}
    }.to change(User, :count).by(-1)
  	expect(response).to redirect_to root_path
  end

end