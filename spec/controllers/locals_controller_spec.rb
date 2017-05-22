require 'rails_helper'

RSpec.describe LocalsController, type: :controller do

	before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.create(id: 1, :email => 'test1@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'Gestore')
   	sign_in @user
  end

  describe "GET #show" do
		it "assegna il locale richiesto a @local" do
      @local = Local.create(id:2, user_id:2, name:"locale2",address:"via Tuscolana,RM", description: "boh", picture: nil, website: "www.ciao.it", telephone: 1234567890, iva: 11005760159, category:"Pub")
      get :show, params: {id: @local}
      expect(assigns(:local)).to eq(@local)
    end
    
    it "mostra lo show dell'evento" do
      @local = Local.create(id:2, user_id:2, name:"locale2",address:"via Tuscolana,RM", description: "boh", picture: nil, website: "www.ciao.it", telephone: 1234567890, iva: 11005760159, category:"Pub")
      get :show, params: {id: @local}
      expect(response).to render_template :show
    end
	end

  describe "POST #create" do
  	
  	context "attributi validi" do
	    it "crea locale correttamente" do
			  expect{
	      	post :create, params: {local: {name:"locale1",address:"via Tuscolana,RM", description: "boh", picture: nil,
			 		website: "www.ciao.it", telephone: 1234567890, iva: 13904601005, category:"Pub"}}
			 	}.to change(Local, :count).by(1)

			 	expect(response).to redirect_to(your_locals_path)
	    end
	  end
    
    context "attributi non validi" do
	    it "non crea locale: iva non valida" do
			  expect{
	      	post :create, params: {local: {name:"locale1",address:"via Tuscolana,RM", description: "boh", picture: nil,
			 		website: "www.ciao.it", telephone: 1234567890, iva: 13904601006, category:"Pub"}}
			 	}.to_not change(Local, :count)

			 	expect(response).to render_template('owner_pages/publish_locals')
	    end

	    it "non crea locale: nome non presente" do
			  expect{
	      	post :create, params: {local: {name: nil, address:"via Tuscolana,RM", description: "boh", picture: nil,
			 		website: "www.ciao.it", telephone: 1234567890, iva: 13904601006, category:"Pub"}}
			 	}.to_not change(Local, :count)

			 	expect(response).to render_template('owner_pages/publish_locals')
	    end

	    it "non crea locale: indirizzo non presente" do
			  expect{
	      	post :create, params: {local: {name:"locale1", address:nil, description: "boh", picture: nil,
			 		website: "www.ciao.it", telephone: 1234567890, iva: 13904601006, category:"Pub"}}
			 	}.to_not change(Local, :count)

			 	expect(response).to render_template('owner_pages/publish_locals')
	    end

	    it "non crea locale: descrizione non presente" do
			  expect{
	      	post :create, params: {local: {name:"locale1",address:"via Tuscolana,RM", description: nil, picture: nil,
			 		website: "www.ciao.it", telephone: 1234567890, iva: 13904601006, category:"Pub"}}
			 	}.to_not change(Local, :count)

			 	expect(response).to render_template('owner_pages/publish_locals')
	    end

	    it "non crea locale: telefono non valido" do
			  expect{
	      	post :create, params: {local: {name:"locale1",address:"via Tuscolana,RM", description: "boh", picture: nil,
			 		website: "www.ciao.it", telephone: 1234567890000, iva: 13904601006, category:"Pub"}}
			 	}.to_not change(Local, :count)

			 	expect(response).to render_template('owner_pages/publish_locals')
	    end
  	end
  end

	describe "DELETE #destroy" do

		it "elimina locale come gestore" do
			@local = Local.create(id:1, user_id:1, name:"locale1",address:"via Tuscolana,RM", description: "boh", picture: nil, website: "www.ciao.it", telephone: 1234567890, iva: 13904601005, category:"Pub")
			expect{ 
	      delete :destroy, params: {:id => @local}
	    }.to change(Local, :count).by(-1)
	  	expect(response).to redirect_to redirect_to your_locals_path
  	end

  	it "elimina locale come admin" do
  		sign_out @user
  		@request.env["devise.mapping"] = Devise.mappings[:admin]
    	@admin = User.create(id: 2, :email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'admin')
   		sign_in @admin

			@local = Local.create(id:2, user_id:2, name:"locale2",address:"via Tuscolana,RM", description: "boh", picture: nil, website: "www.ciao.it", telephone: 1234567890, iva: 11005760159, category:"Pub")
			expect{ 
	      delete :destroy, params: {:id => @local}
	    }.to change(Local, :count).by(-1)
	  	expect(response).to redirect_to redirect_to locals_all_path
  	end

  	it "notifica quando si elimina locale come admin" do
  		sign_out @user
  		@request.env["devise.mapping"] = Devise.mappings[:admin]
    	@admin = User.create(id: 2, :email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'admin')
   		sign_in @admin

			@local = Local.create(id:2, user_id:2, name:"locale2",address:"via Tuscolana,RM", description: "boh", picture: nil, website: "www.ciao.it", telephone: 1234567890, iva: 11005760159, category:"Pub")
			expect{ 
	      delete :destroy, params: {:id => @local}
	    }.to change(Notification, :count).by(1)
	  	expect(response).to redirect_to redirect_to locals_all_path
  	end

	end

	describe "PUT #update" do

		let(:new_attributes) {{ name: "new_name", description: "new_desc" }}

		it "modifica locale" do
      @local = Local.create(id:2, user_id:2, name:"locale2",address:"via Tuscolana,RM", description: "boh", picture: nil, website: "www.ciao.it", telephone: 1234567890, iva: 11005760159, category:"Pub")
      put :update, params: {:id => @local, :local => new_attributes}
      @local.reload
			expect(@local.name).to eq('new_name')
			expect(@local.description).to eq('new_desc')
			expect(response).to redirect_to(@local)
    end
	end

	describe "Segnalazione locale" do
		it "segnala locale" do
			@request.env["devise.mapping"] = Devise.mappings[:admin]
    	@admin = User.create(id: 2, :email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'admin')
			@local = Local.create(id:2, user_id:2, name:"locale2",address:"via Tuscolana,RM", description: "boh", picture: nil, website: "www.ciao.it", telephone: 1234567890, iva: 11005760159, category:"Pub")
      expect{
      	post :report, params: {id: @local}
      }.to change(Notification, :count).by(1)
      @local.reload
			expect(response).to redirect_to(@local)
		end
	end

end