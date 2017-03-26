class EventsController < ApplicationController
before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  #before_action :correct_user,   only: [:edit, :update, :destroy]

  def show
    @event = Event.find(params[:id])
    #@microposts = @user.microposts.paginate(page: params[:page], :per_page => 10)
  end

  #def search
  #  @events = Event.all
  #  if params[:search]
  #    @events = Event.search(params[:search]).order("created_at DESC")
  #  else
  #    @events = Event.all.order("created_at DESC")
  #  end
  #end

  def create
  	@local= Local.find_by(id: params[:event][:local_id]) #prendi id locale dal select nel form
    @event = @local.events.build(event_params)
    #@event = Event.new(event_params)
    
    if @event.save
      flash[:success] = "Evento aggiunto!"
      redirect_to publish_events_path
    else
      render 'owner_pages/publish_events'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:success] = "Evento eliminato!"
    redirect_to request.referrer || publish_events_path
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      flash[:success] = "Evento modificato"
      redirect_to @event
    else
      render 'edit'
    end
  end

  private

    def event_params
      params.require(:event).permit(:name, :description, :local_id, :start, :end, :picture)
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