class LocalsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  #before_action :correct_user,   only: [:edit, :update, :destroy]

  def show
    @local = Local.find(params[:id])
    #@microposts = @user.microposts.paginate(page: params[:page], :per_page => 10)
  end


  def create
    @local = current_user.locals.build(local_params)
    if @local.save
      flash[:success] = "Locale aggiunto!"
      redirect_to publish_locals_path
    else
      render 'owner_pages/publish_locals'
    end
  end

  def destroy
    @local = Local.find(params[:id])
    @local.destroy
    flash[:success] = "Locale eliminato!"
    redirect_to request.referrer || publish_locals_path
  end

  def edit
    @local = Local.find(params[:id])
  end

  def update
    @local = Local.find(params[:id])
    if @local.update_attributes(local_params)
      flash[:success] = "Locale modificato"
      redirect_to @local
    else
      render 'edit'
    end
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