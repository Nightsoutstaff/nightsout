class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  before_action :set_comment, only: [ :reply, :edit, :update, :destroy ]
 
  def reply
    @reply = @commentable.comments.build(parent: @comment)
  end
 
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    #@comment.likes = 0
    
    #respond_to do |format|
      if @comment.save
        if @comment.commentable_type == 'Local' 
          if @comment.parent_id == nil
            if current_user != @commentable.user
              Notification.create(text: "Il tuo locale è stato commentato!", comment_id: @comment.id, additional_info: current_user.name, local_id: @comment.commentable_id, user_id: Local.find(@comment.commentable_id).user_id)
            end
            redirect_to local_path(@commentable, anchor: 'comment_' + @comment.id.to_s)
          else
            if (current_user != Comment.find(@comment.parent_id).user) && (current_user != Local.find(@comment.commentable_id).user)
              Notification.create(text: "Qualcuno ha risposto al tuo commento!", comment_id: @comment.id, additional_info: current_user.name, local_id: @comment.commentable_id, user_id: Comment.find(@comment.parent_id).user.id)
            elsif current_user == Local.find(@comment.commentable_id).user
              Notification.create(text: "Qualcuno ha risposto al tuo commento!", comment_id: @comment.id, additional_info: Local.find(@comment.commentable_id).name, local_id: @comment.commentable_id, user_id: Comment.find(@comment.parent_id).user.id)
            end
            redirect_to local_path(@commentable, anchor: 'comment_' + @comment.parent_id.to_s)
          end 
        elsif @comment.commentable_type == 'Event' 
          if @comment.parent_id == nil
            if current_user != @commentable.local.user
              Notification.create(text: "Il tuo evento è stato commentato!", comment_id: @comment.id, additional_info: current_user.name, event_id: @comment.commentable_id, user_id: Event.find(@comment.commentable_id).local.user_id)
            end
            redirect_to event_path(@commentable, anchor: 'comment_' + @comment.id.to_s)
          else
            if (current_user != Comment.find(@comment.parent_id).user) && (current_user != Event.find(@comment.commentable_id).local.user)
              Notification.create(text: "Qualcuno ha risposto al tuo commento!", comment_id: @comment.id, additional_info: current_user.name, event_id: @comment.commentable_id, user_id: Comment.find(@comment.parent_id).user.id)
             elsif current_user == Event.find(@comment.commentable_id).local.user
              Notification.create(text: "Qualcuno ha risposto al tuo commento!", comment_id: @comment.id, additional_info: Event.find(@comment.commentable_id).local.name, event_id: @comment.commentable_id, user_id: Comment.find(@comment.parent_id).user.id)
            end
            redirect_to event_path(@commentable, anchor: 'comment_' + @comment.parent_id.to_s)
          end
        end

        #format.html { redirect_to @commentable, notice: "Commento aggiunto."}
        #format.json { render json: @comment }
        #format.js
      else
        redirect_to @commentable, notice: "Commento non aggiunto. Riprova."
        #format.html { render :back, notice: "Commento non aggiunto. Riprova." }
        #format.json { render json: @comment.errors }
        #format.js
      end
    #end
  end
 
  def edit
  end
 
  def update
    if current_user == @comment.user
      respond_to do |format|
        if @comment.update(comment_params)
          format.html { redirect_to @commentable, notice: "Commento aggiornato."}
          format.json { render json: @comment }
          format.js
        else
          format.html { render :back, notice: "Commento non aggiornato. Riprova." }
          format.json { render json: @comment.errors }
          format.js
        end
      end
    else
      redirect_to @commentable
    end
  end
 
  def destroy
    if current_user == @comment.user
      if @comment.errors.empty?
        Notification.where(comment_id: @comment.id).destroy_all
        @comment.destroy 
        respond_to do |format|
          format.html { redirect_to @commentable, notice: "Commento eliminato."}
          format.json { head :no_content }
          format.js
        end
      end
    elsif current_user.role == 'admin' && current_user != @comment.user 
      if @comment.errors.empty?
        @text = @comment.content
        @receiver_id = @comment.user.id
        @comment.destroy 
        Notification.create(text: "Commento eliminato da Admin!", additional_info: @text, user_id: @receiver_id)
        respond_to do |format|
          format.html { redirect_to @commentable, notice: "Commento eliminato."}
          format.json { head :no_content }
          format.js
        end
      end
    else
      redirect_to @commentable
    end
  end

  def upvote
    @comment = @commentable.comments.find(params[:id])
    @comment.liked_by current_user
    @comment.update_attributes(likes: @comment.likes + 1)
    respond_to do |format|
      format.html { redirect_to @commentable }
      format.json { render json: @comment }
      format.js
    end
  end

  def downvote
    @comment = @commentable.comments.find(params[:id])
    @comment.downvote_from current_user
    @comment.update_attributes(likes: @comment.likes - 1)
    respond_to do |format|
      format.html { redirect_to @commentable }
      format.json { render json: @comment }
      format.js
    end
  end

  def report
    @comment = @commentable.comments.find(params[:id])
    if @comment.commentable_type == 'Local' 
      Notification.create(text: "Segnalazione commento!", additional_info: current_user.name, comment_id: @comment.id, local_id: @comment.commentable_id, user_id: User.find_by(role: 'admin').id)
    elsif @comment.commentable_type == 'Event' 
      Notification.create(text: "Segnalazione commento!", additional_info: current_user.name, comment_id: @comment.id, event_id: @comment.commentable_id, user_id: User.find_by(role: 'admin').id)
    end
    respond_to do |format|
      format.html { redirect_to @commentable, notice: "Commento segnalato agli admin."}
      format.json { head :no_content }
      format.js
    end
  end
 
  private
 
  def set_commentable
    resource, id = request.path.split('/')[1,2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end
 
  def set_comment
    begin
      @comment = @commentable.comments.find(params[:id])
    rescue => e
      logger.error "#{e.class.name} : #{e.message}"
      @comment = @commentable.comments.build
      @comment.errors.add(:base, :recordnotfound, message: "Commento inesistente o già eliminato.")
    end
  end
 
  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end