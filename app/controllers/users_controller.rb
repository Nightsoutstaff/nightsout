class UsersController < ApplicationController

	#metodi da aggiungere a quelli del controller creato da Devise

	def following_event
        @user  = User.find(params[:id])
        @events = @user.following_event.paginate(page: params[:page])
        render 'client_pages/following'
 	end

 	def following_local
        @user  = User.find(params[:id])
        @locals = @user.following_local.paginate(page: params[:page])
        render 'client_pages/following'
 	end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        #flash[:success] = "Utente eliminato!"
        redirect_to root_path
    end

end
    

