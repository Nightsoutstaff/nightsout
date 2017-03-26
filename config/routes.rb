Rails.application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations", :sessions => "users/sessions"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #devise_scope :user do
  #	delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  #end

  resources :users
  resources :locals
  resources :events

  root 'pages#home'
  get '/publish_events', to: 'owner_pages#publish_events'
  get '/publish_locals', to: 'owner_pages#publish_locals'
  get '/all_events', to: 'client_pages#all_events'
  get '/following', to: 'client_pages#following'
  #get '/event_page', to: 'client_pages#event_page'
  #get '/local_page', to: 'client_pages#local_page'
  get  '/help',    to: 'pages#help'
  get  '/about',   to: 'pages#about'
  get  '/contact', to: 'pages#contact'
  get  '/search',    to: 'pages#search'

end
