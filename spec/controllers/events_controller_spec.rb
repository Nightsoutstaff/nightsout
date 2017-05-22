require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.create(id: 1, :email => 'test1@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'Gestore')
   	sign_in @user
   	@local = Local.create(id:1, user_id:1, name:"locale1",address:"via Tuscolana,RM", description: "boh", picture: nil, website: "www.ciao.it", telephone: 1234567890, iva: 13904601005, category:"Pub")  
  end

  describe "GET #show" do
		
		it "assegna evento richiesto a @event" do
	    @event = Event.create(id:2, name: "evento",description: "cose varie",local_id:@local.id, start:"2017-05-14 17:04:00", end: "2017-05-16 19:05:00", picture: nil)
	    get :show, params: {id: @event}
	    expect(assigns(:event)).to eq(@event)
	   end
	    
	  it "mostra lo show dell'evento" do
	    @event = Event.create(id:2, name: "evento",description: "cose varie",local_id:@local.id, start:"2017-05-14 17:04:00", end: "2017-05-16 19:05:00", picture: nil)
	    get :show, params: {id: @event}
	    expect(response).to render_template :show
	  end
	end

  describe "POST #create" do
  	
  	context "attributi validi" do
	    it "crea evento correttamente" do
			  expect{
	      	post :create, params: {event: {name: "evento",description: "cose varie",local_id: @local.id, start:"2017-05-14 17:04:00", end: "2017-05-16 19:05:00", picture: nil}}
			 	}.to change(Event, :count).by(1)

			 	expect(response).to redirect_to(your_events_path)
	    end

	    it "notifica crea evento correttamente di locale seguito" do
	    	@relationship = LocalRelationship.create(id:1, follower_id: 1, followed_id: 1)
			  expect{
	      	post :create, params: {event: {name: "evento",description: "cose varie",local_id: @local.id, start:"2017-05-14 17:04:00", end: "2017-05-16 19:05:00", picture: nil}}
			 	}.to change(Notification, :count).by(1)

			 	expect(response).to redirect_to(your_events_path)
	    end
		end

		context "attributi non validi" do
	    it "non crea evento: nome non presente" do
			  expect{
	      	post :create, params: {event: {name: nil,description: "cose varie",local_id: @local.id, start:"2017-05-14 17:04:00", end: "2017-05-16 19:05:00", picture: nil}}
			 	}.to_not change(Event, :count)

			 	expect(response).to render_template('owner_pages/publish_events')
	    end

	    it "non crea evento: inizio evento errato" do
			  expect{
	      	post :create, params: {event: {name: "evento",description: "cose varie",local_id: @local.id, start:"2018-05-14 17:04:00", end: "2017-05-16 19:05:00", picture: nil}}
			 	}.to_not change(Event, :count)

			 	expect(response).to render_template('owner_pages/publish_events')
	    end

	    it "non crea evento: fine evento errato" do
			  expect{
	      	post :create, params: {event: {name: "evento",description: "cose varie",local_id: @local.id, start:"2017-05-14 17:04:00", end: "2016-05-16 19:05:00", picture: nil}}
			 	}.to_not change(Event, :count)

			 	expect(response).to render_template('owner_pages/publish_events')
	    end
  	end
  end

  describe "DELETE #destroy" do

		it "elimina evento come gestore" do
			@event = Event.create(id:1, name: "evento",description: "cose varie",local_id: @local.id, start:"2017-05-14 17:04:00", end: "2017-05-16 19:05:00", picture: nil)
			expect{ 
	      delete :destroy, params: {:id => @event}
	    }.to change(Event, :count).by(-1)
	  	expect(response).to redirect_to your_events_path
  		end

	  	it "elimina evento come admin" do
	  		sign_out @user
	  		@request.env["devise.mapping"] = Devise.mappings[:admin]
	    	@admin = User.create(id: 2, :email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'admin')
	   		sign_in @admin

				@event = Event.create(id:2, name: "evento",description: "cose varie",local_id: @local.id, start:"2017-05-14 17:04:00", end: "2017-05-16 19:05:00", picture: nil)
				expect{ 
		      delete :destroy, params: {:id => @event}
		    }.to change(Event, :count).by(-1)
		  	expect(response).to redirect_to events_all_path
	  	end

	  	it "notifica quando si elimina evento come admin" do
	  		sign_out @user
	  		@request.env["devise.mapping"] = Devise.mappings[:admin]
	    	@admin = User.create(id: 2, :email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'admin')
	   		sign_in @admin

				@event = Event.create(id:2, name: "evento",description: "cose varie",local_id: @local.id, start:"2017-05-14 17:04:00", end: "2017-05-16 19:05:00", picture: nil)
				expect{ 
		      delete :destroy, params: {:id => @event}
		    }.to change(Notification, :count).by(1)
		  	expect(response).to redirect_to events_all_path
	  	end
	end

	describe "PUT #update" do

		let(:new_attributes) {{ name: "new_name", description: "new_desc" }}

		it "modifica evento" do
	      @event = Event.create(id:2, name: "evento",description: "cose varie",local_id: @local.id, start:"2017-05-14 17:04:00", end: "2017-05-16 19:05:00", picture: nil)
	      put :update, params: {:id => @event, :event => new_attributes}
	      @event.reload
				expect(@event.name).to eq('new_name')
				expect(@event.description).to eq('new_desc')
				expect(response).to redirect_to(@event)
	    end
	end

	describe "Segnalazione evento" do
		it "segnala evento" do
			@request.env["devise.mapping"] = Devise.mappings[:admin]
    	@admin = User.create(id: 2, :email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'admin')
			@event = Event.create(id:2, name: "evento",description: "cose varie",local_id: @local.id, start:"2017-05-14 17:04:00", end: "2017-05-16 19:05:00", picture: nil)
	    expect{
      	post :report, params: {id: @event}
      }.to change(Notification, :count).by(1)
      @event.reload
			expect(response).to redirect_to(@event)
		end
	end
end