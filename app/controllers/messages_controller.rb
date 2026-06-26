class MessagesController < ApplicationController
  before_action :require_login

  def index
    @project = Project.find(params[:project_id])
    @messages = @project.messages.includes(:author).order(created_at: :desc)
  end

  def show
    @message = Message.find(params[:id])
    @project = @message.project
    @comments = @message.comments.includes(:author).order(created_at: :asc)
  end

  def new
    @project = Project.find(params[:project_id])
    @message = @project.messages.new
  end

  def create
    @project = Project.find(params[:project_id])
    @message = @project.messages.new(message_params)
    @message.author = current_user

    if @message.save
      respond_to do |format|
        format.html { redirect_to [@project, @message], notice: "Message posted." }
        format.turbo_stream
      end
    else
      @messages = @project.messages.includes(:author).order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @project = @message.project
    @message.destroy

    respond_to do |format|
      format.html { redirect_to project_messages_path(@project), notice: "Message deleted." }
      format.turbo_stream
    end
  end

  private

  def message_params
    params.require(:message).permit(:title, :body, :message_type)
  end
end
