Rails.application.routes.draw do



  post '/rate' => 'rater#create', :as => 'rate'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations", :sessions => "users/sessions"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # devise_scope :user do
  #	 delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end

 

  resources :users do
    member do
      get :following_event, :following_local, :destroy
    end
  end

  resources :events do
    member do
      get :followers
      put "signal", to: "events#report"
    end
    resources :comments, except: [:index, :new, :show] do
      member do
        get :reply
        put "like", to: "comments#upvote"
        put "dislike", to: "comments#downvote"
        put "signal", to: "comments#report"
      end
    end
  end

  resources :locals do
    member do
      get :followers
      put "signal", to: "locals#report"
    end
    resources :comments, except: [:index, :new, :show] do
      member do
        get :reply
        put "like", to: "comments#upvote"
        put "dislike", to: "comments#downvote"
        put "signal", to: "comments#report"
      end
    end
  end

  resources :event_relationships, only: [:create, :destroy]
  resources :local_relationships, only: [:create, :destroy]
  #resources :comments, only: [:index, :create]


  root 'pages#home'
  
  get '/publish_events', to: 'owner_pages#publish_events'
  get '/publish_locals', to: 'owner_pages#publish_locals'
  get '/all_events', to: 'client_pages#all_events'
  get '/following', to: 'client_pages#following'
  get '/your_locals', to: 'owner_pages#your_locals'
  get '/your_events', to: 'owner_pages#your_events'
  get '/help',    to: 'pages#help'
  get '/notifications',    to: 'pages#notifications'
  get '/about',   to: 'pages#about'
  get '/contact', to: 'pages#contact'
  get '/search',    to: 'pages#search'
  get '/banned', to: 'pages#banned'
  get '/events_all', to: 'admin_pages#events_all'
  get '/locals_all', to: 'admin_pages#locals_all'
  get '/users_all', to: 'admin_pages#users_all'
  post 'admin_pages/ban' => 'admin_pages#ban', :as => :ban
  post 'admin_pages/unban' => 'admin_pages#unban', :as => :unban
 # get '/comments/new/(:parent_id)', to: 'comments#new', as: :new_comment

end
