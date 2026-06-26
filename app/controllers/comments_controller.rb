class CommentsController < ApplicationController
  before_action :require_login

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.new(comment_params)
    @comment.author = current_user

    if @comment.save
      respond_to do |format|
        format.html { redirect_back(fallback_location: home_path) }
        format.turbo_stream
      end
    else
      redirect_back(fallback_location: home_path, alert: "Comment could not be saved.")
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable
    @comment.destroy

    respond_to do |format|
      format.html { redirect_back(fallback_location: home_path) }
      format.turbo_stream
    end
  end

  private

  def find_commentable
    if params[:message_id]
      Message.find(params[:message_id])
    elsif params[:todo_list_id]
      TodoList.find(params[:todo_list_id])
    elsif params[:event_id]
      Event.find(params[:event_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
