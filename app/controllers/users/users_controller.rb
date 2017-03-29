class UsersController < ApplicationController

	#metodi da aggiungere a quelli del controller creato da Devise

	def following_event
    @user  = User.find(params[:id])
    #@users = @user.following.paginate(page: params[:page])
    #@user  = current_user
    @events = @user.following_event.paginate(page: params[:page])
    render 'client_pages/following'
 	end

 	def following_local
    @user  = User.find(params[:id])
    #@users = @user.following.paginate(page: params[:page])
    #@user  = current_user
    @locals = @user.following_local.paginate(page: params[:page])
    render 'client_pages/following'
 	end

