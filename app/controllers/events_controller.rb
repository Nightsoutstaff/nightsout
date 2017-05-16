class EventsController < ApplicationController
before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  #before_action :correct_user,   only: [:edit, :update, :destroy]

  def show
    @event = Event.find(params[:id])
  end

  def create
    @local = Local.find_by(id: params[:event][:local_id]) #prendi id locale dal select nel form
    @event = @local.events.build(event_params)   
    if @event.save
      flash[:success] = "Evento aggiunto!"
      Local.addFollowingLocalPublishEventNotification(@local.id, @event.id, @event.name)
      redirect_to your_events_path
    else
      render 'owner_pages/publish_events'
    end  
  end

  def destroy
    #Se è l'admin che ha eliminato l'evento
    @event = Event.find(params[:id])
    if(current_user.role == 'admin')
        Notification.create(text: "Evento eliminato da Admin!", mentioned_by:"", event_id: @event.id, local_id: @event.local.id, end: @event.start, user_id: @event.local.user.id)
    end
    @event.destroy
    flash[:success] = "Evento eliminato!"
    if(current_user.role == 'admin')
      redirect_to events_all_path
    else
      redirect_to your_events_path
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      if params[:remove_photo] == 'yes'
        @event.remove_picture!
        @event.save
      end
      flash[:success] = "Evento modificato"
      redirect_to @event
    else
      render 'edit'
    end
  end

  def followers
    @event  = Event.find(params[:id])
    @events = @event.followers.paginate(page: params[:page])
    render 'client_pages/following'
  end

  def report
    @event = Event.find(params[:id])
    Notification.create(text: "Segnalazione evento!", written_by: current_user.name, event_id: @event.id, user_id: User.find_by(role: 'admin').id)
    redirect_to @event
  end

  private

    def event_params
      params.require(:event).permit(:name, :description, :local_id, :start, :end_time, :picture)
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