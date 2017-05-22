require "rails_helper"

RSpec.describe CommentsController, type: :controller do 

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.create(id: 1, :email => 'test1@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'Gestore')
   	sign_in @user
   	@local = Local.create(id:1, user_id:@user.id, name:"locale1",address:"via Tuscolana,RM", description: "boh", picture: nil, website: "www.ciao.it", telephone: "1234567890", iva: "13904601005", category:"Pub")  
   	@event = Event.create(id:1, name: "evento",description: "cose varie",local_id:@local.id, start:"2017-05-14 17:04:00", end: "2017-05-16 19:05:00", picture: nil)
	end

  describe "POST #create" do 

		context "attributi validi su proprio locale o evento" do

	    it "crea commento a proprio locale correttamente" do
			  expect{
			  	post :create, params: {:local_id => @local.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			 	}.to change(Comment, :count).by(1)

			 	expect(response).to redirect_to(local_path(@local, anchor: 'comment_1'))
	    end

	    it "no notifica su crea commento a locale correttamente" do
			  expect{
			  	post :create, params: {:local_id => @local.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			 	}.to_not change(Notification, :count)

			 	expect(response).to redirect_to(local_path(@local, anchor: 'comment_1'))
	    end

	    it "crea risposta a proprio commento a locale correttamente" do
	    	post :create, params: {:local_id => @local.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			  expect{
			  	post :create, params: {:local_id => @local.id, comment: {id: 2, content:"ciao", parent_id:1, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			 	}.to change(Comment, :count).by(1)

			 	expect(response).to redirect_to(local_path(@local, anchor: 'comment_1'))
	    end

	    it "no notifica su crea risposta a proprio commento a locale correttamente" do
	    	post :create, params: {:local_id => @local.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			  expect{
			  	post :create, params: {:local_id => @local.id, comment: {id: 2, content:"ciao", parent_id:1, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			 	}.to_not change(Notification, :count)

			 	expect(response).to redirect_to(local_path(@local, anchor: 'comment_1'))
	    end

	    it "crea commento su proprio evento correttamente" do
			  expect{
			  	post :create, params: {:event_id => @event.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user.id, commentable_type:"Event", commentable_id: @event.id, likes: 0}}
			 	}.to change(Comment, :count).by(1)

			 	expect(response).to redirect_to(event_path(@event, anchor: 'comment_1'))
	    end

	    it "no notifica crea commento su proprio evento correttamente" do
			  expect{
			  	post :create, params: {:event_id => @event.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user.id, commentable_type:"Event", commentable_id: @event.id, likes: 0}}
			 	}.to_not change(Notification, :count)

			 	expect(response).to redirect_to(event_path(@event, anchor: 'comment_1'))
	    end

	    it "crea risposta a proprio commento su proprio evento correttamente" do
			  expect{
			  	post :create, params: {:event_id => @event.id, comment: {id: 2, content:"ciao", parent_id:1, user_id: @user.id, commentable_type:"Event", commentable_id: @event.id, likes: 0}}
			 	}.to change(Comment, :count).by(1)

			 	expect(response).to redirect_to(event_path(@event, anchor: 'comment_1'))
	    end

	    it "no notifica crea risposta a proprio commento su proprio evento correttamente" do
			  expect{
			  	post :create, params: {:event_id => @event.id, comment: {id: 2, content:"ciao", parent_id:1, user_id: @user.id, commentable_type:"Event", commentable_id: @event.id, likes: 0}}
			 	}.to_not change(Notification, :count)

			 	expect(response).to redirect_to(event_path(@event, anchor: 'comment_1'))
	    end

		end

		context "attributi validi su locale o evento altrui" do

			before(:each) do
				sign_out @user
				@request.env["devise.mapping"] = Devise.mappings[:user2]
    		@user2 = User.create(id: 2, :email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'Cliente')
   			sign_in @user2
   		end

	    it "crea commento a locale altrui correttamente" do
			  expect{
			  	post :create, params: {:local_id => @local.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user2.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			 	}.to change(Comment, :count).by(1)

			 	expect(response).to redirect_to(local_path(@local, anchor: 'comment_1'))
	    end

	    it "si notifica su crea commento a locale altrui correttamente" do
			  expect{
			  	post :create, params: {:local_id => @local.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user2.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			 	}.to change(Notification, :count).by(1)

			 	expect(response).to redirect_to(local_path(@local, anchor: 'comment_1'))
	    end

	    it "crea risposta a commento altrui su locale correttamente" do
	    	post :create, params: {:local_id => @local.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user2.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
	    	sign_out @user2
	    	sign_in @user
	    	expect{
			  	post :create, params: {:local_id => @local.id, comment: {id: 2, content:"ciao", parent_id:1, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			 	}.to change(Comment, :count).by(1)

			 	expect(response).to redirect_to(local_path(@local, anchor: 'comment_1'))
	    end

	    it "si notifica su crea risposta a commento altrui su locale correttamente" do
	    	post :create, params: {:local_id => @local.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user2.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
	    	sign_out @user2
	    	sign_in @user
	    	expect{
			  	post :create, params: {:local_id => @local.id, comment: {id: 2, content:"ciao", parent_id:1, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			 	}.to change(Notification, :count).by(1)

			 	expect(response).to redirect_to(local_path(@local, anchor: 'comment_1'))
	    end

	    it "crea commento su evento altrui correttamente" do
			  expect{
			  	post :create, params: {:event_id => @event.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user.id, commentable_type:"Event", commentable_id: @event.id, likes: 0}}
			 	}.to change(Comment, :count).by(1)

			 	expect(response).to redirect_to(event_path(@event, anchor: 'comment_1'))
	    end

	    it "si notifica crea commento su evento altrui correttamente" do
			  expect{
			  	post :create, params: {:event_id => @event.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user2.id, commentable_type:"Event", commentable_id: @event.id, likes: 0}}
			 	}.to change(Notification, :count).by(1)

			 	expect(response).to redirect_to(event_path(@event, anchor: 'comment_1'))
	    end

	    it "crea risposta a commento altrui su evento correttamente" do
	    	post :create, params: {:event_id => @event.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user2.id, commentable_type:"Event", commentable_id: @event.id, likes: 0}}
	    	sign_out @user2
	    	sign_in @user
	    	expect{
			  	post :create, params: {:event_id => @event.id, comment: {id: 2, content:"ciao", parent_id:1, user_id: @user.id, commentable_type:"Event", commentable_id: @event.id, likes: 0}}
			 	}.to change(Comment, :count).by(1)

			 	expect(response).to redirect_to(event_path(@event, anchor: 'comment_1'))
	    end

	    it "si notifica su crea risposta a commento altrui correttamente" do
	    	post :create, params: {:event_id => @event.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user2.id, commentable_type:"Event", commentable_id: @event.id, likes: 0}}
	    	sign_out @user2
	    	sign_in @user
	    	expect{
			  	post :create, params: {:event_id => @event.id, comment: {id: 2, content:"ciao", parent_id:1, user_id: @user.id, commentable_type:"Event", commentable_id: @event.id, likes: 0}}
			 	}.to change(Notification, :count).by(1)

			 	expect(response).to redirect_to(event_path(@event, anchor: 'comment_1'))
	    end

		end

		context "attributi non validi" do

	    it "contenuto nullo in commento su locale" do
			  expect{
			  	post :create, params: {:local_id => @local.id, comment: {id: 1, content:nil, parent_id:nil, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			 	}.to_not change(Comment, :count)

			 	expect(response).to redirect_to(@local)
			 	expect(flash[:notice]).to be_present
	    end

	    it "contenuto nullo in commento su evento" do
			  expect{
			  	post :create, params: {:event_id => @event.id, comment: {id: 1, content:nil, parent_id:nil, user_id: @user.id, commentable_type:"Event", commentable_id: @event.id, likes: 0}}
			 	}.to_not change(Comment, :count)

			 	expect(response).to redirect_to(@event)
			 	expect(flash[:notice]).to be_present
	    end
		end
  end

  describe "POST #reply" do 
   	it "rispondi" do
		  expect{
			 	post :create, params: {:local_id => @local.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			}.to change(Comment, :count).by(1)
		end
	end

	describe "DELETE #destroy" do

		it "elimina proprio commento" do
			post :create, params: {:local_id => @local.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			expect{ 
	      delete :destroy, params: {:id => 1, :local_id => @local.id}
	    }.to change(Comment, :count).by(-1)
	  	#expect(response).to redirect_to your_events_path
  	end

	  it "commento eliminato da admin" do
	  	post :create, params: {:local_id => @local.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			
	  	sign_out @user
	  	@request.env["devise.mapping"] = Devise.mappings[:admin]
	    @admin = User.create(id: 2, :email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'admin')
	   	sign_in @admin

			expect{ 
		    delete :destroy, params: {:id => 1, :local_id => @local.id}
		  }.to change(Comment, :count).by(-1)
		  #expect(response).to redirect_to events_all_path
	  end

	  it "notifica quando un commento viene eliminato da admin" do
	  	post :create, params: {:local_id => @local.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			
	  	sign_out @user
	  	@request.env["devise.mapping"] = Devise.mappings[:admin]
	    @admin = User.create(id: 2, :email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'admin')
	   	sign_in @admin

			expect{ 
		    delete :destroy, params: {:id => 1, :local_id => @local.id}
		  }.to change(Notification, :count).by(1)
		  #expect(response).to redirect_to events_all_path
	  end
	end

	describe "PUT #update" do

		let(:new_attributes) {{content: "new_content"}}

		it "modifica commento a locale" do
      post :create, params: {:local_id => @local.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			put :update, params: {:id => 1, :local_id => @local.id, :comment => new_attributes}
      @local.reload
			expect(Comment.find(1).content).to eq('new_content')
			expect(response).to redirect_to(@local)
    end

    it "modifica commento a evento" do
      post :create, params: {:event_id => @event.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user.id, commentable_type:"Event", commentable_id: @event.id, likes: 0}}
			put :update, params: {:id => 1, :event_id => @event.id, :comment => new_attributes}
      @event.reload
			expect(Comment.find(1).content).to eq('new_content')
			expect(response).to redirect_to(@event)
    end
	end

	describe "Segnalazione commento" do
		it "segnala commento a locale" do
			post :create, params: {:local_id => @local.id, comment: {id: 1, content:"commento razzista", parent_id:nil, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			sign_out @user
			@request.env["devise.mapping"] = Devise.mappings[:admin]
    	@admin = User.create(id: 2, :email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'admin')
			@request.env["devise.mapping"] = Devise.mappings[:user2]
   		@user2 = User.create(id: 3, :email => 'test3@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'Cliente')
   		sign_in @user2
   		expect{
      	post :report, params: {:id => 1, :local_id => @local.id}
      }.to change(Notification, :count).by(1)
      @local.reload
			expect(response).to redirect_to(@local)
		end

		it "segnala commento a evento" do
			post :create, params: {:event_id => @event.id, comment: {id: 1, content:"commento razzista", parent_id:nil, user_id: @user.id, commentable_type:"Event", commentable_id: @event.id, likes: 0}}
			sign_out @user
			@request.env["devise.mapping"] = Devise.mappings[:admin]
    	@admin = User.create(id: 2, :email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'admin')
			@request.env["devise.mapping"] = Devise.mappings[:user2]
   		@user2 = User.create(id: 3, :email => 'test3@example.com', :password => 'password', :password_confirmation => 'password',:name => 'fede', :city => 'Roma, RM, Italia', :role => 'Cliente')
   		sign_in @user2
   		expect{
      	post :report, params: {:id => 1, :event_id => @event.id}
      }.to change(Notification, :count).by(1)
      @event.reload
			expect(response).to redirect_to(@event)
		end
	end

	describe "Like e dislike a commento" do

		it "metto mi piace a un commento e poi non mi piace più" do
			post :create, params: {:local_id => @local.id, comment: {id: 1, content:"ciao", parent_id:nil, user_id: @user.id, commentable_type:"Local", commentable_id: @local.id, likes: 0}}
			put :upvote, params: {:id => 1, :local_id => @local.id}
      @local.reload
			expect(Comment.find(1).likes).to eq(1)
			expect(response).to redirect_to(@local)

			put :downvote, params: {:id => 1, :local_id => @local.id}
      @local.reload
			expect(Comment.find(1).likes).to eq(0)
			expect(response).to redirect_to(@local)
		end

	end

end

