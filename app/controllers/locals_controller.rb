class LocalsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  #before_action :correct_user,   only: [:edit, :update, :destroy]

  def show
    @local = Local.find(params[:id])
    @events = @local.events.paginate(page: params[:page], :per_page => 5)
    #@commentable = @local
    #@comment = @local.comments.build
    #@reply = @local.comments.build(parent: @comment)
    #@microposts = @user.microposts.paginate(page: params[:page], :per_page => 10)
  end

  def create
    @local = current_user.locals.build(local_params)
    if @local.save
      flash[:success] = "Locale aggiunto!"
      redirect_to your_locals_path
    else
      render 'owner_pages/publish_locals'
    end
  end

  def destroy
    @local = Local.find(params[:id])
    if(current_user.role == 'admin')
        Notification.create(text: "Locale eliminato da Admin!", mentioned_by:"", local_id: @local.id, user_id: @local.user.id)
    end
    Local.deleteFollowingLocal(@local.id, @local.name)
    @local.destroy
    flash[:success] = "Locale eliminato!"
    if(current_user.role == 'admin')
      redirect_to locals_all_path
    else
      redirect_to your_locals_path
    end
  end

  def edit
    @local = Local.find(params[:id])
  end

  def update
    @local = Local.find(params[:id])
    if @local.update_attributes(local_params)
      if params[:remove_photo] == 'yes'
        @local.remove_picture!
        @local.save
      end
      flash[:success] = "Locale modificato"
      redirect_to @local
    else
      render 'edit'
    end
  end

  def followers
    @local  = Local.find(params[:id])
    @locals = @local.followers.paginate(page: params[:page])
    render 'client_pages/following'
  end

  def report
    @local = Local.find(params[:id])
    Notification.create(text: "Segnalazione locale!", written_by: current_user.name, local_id: @local.id, user_id: User.find_by(role: 'admin').id)
    redirect_to @local
  end

  private

    def local_params
      params.require(:local).permit(:name, :address, :description, :picture, :website, :telephone, :iva, :category)
    end

    #def correct_local
     # @local = current_user.locals.find_by(id: params[:id])
      #redirect_to publish_locals_path if @local.nil?
    #end

    #def correct_user
      #@user = User.find(params[:id])
      #redirect_to(edit_user_registration_path) unless @user == current_user
    #end
end