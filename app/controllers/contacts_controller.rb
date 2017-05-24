class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash.now[:notice] = 'Grazie per averci contattato. Le faremo sapere presto.'
      render :new
    else
      flash.now[:error] = 'Messaggio non inviato. Riprova.'
      render :new
    end
  end
end