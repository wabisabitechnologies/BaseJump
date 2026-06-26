class EventsController < ApplicationController
  before_action :require_login

  def index
    @project = Project.find(params[:project_id])
    @events = @project.events.includes(:author).order(start_date: :asc)
  end

  def show
    @event = Event.find(params[:id])
    @project = @event.project
    @comments = @event.comments.includes(:author).order(created_at: :asc)
  end

  def new
    @project = Project.find(params[:project_id])
    @event = @project.events.new
  end

  def create
    @project = Project.find(params[:project_id])
    @event = @project.events.new(event_params)
    @event.author = current_user

    if @event.save
      respond_to do |format|
        format.html { redirect_to [@project, @event], notice: "Event created." }
        format.turbo_stream
      end
    else
      @events = @project.events.includes(:author).order(start_date: :asc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @project = @event.project
    @event.destroy

    respond_to do |format|
      format.html { redirect_to project_events_path(@project), notice: "Event deleted." }
      format.turbo_stream
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :start_date, :end_date, :video_link)
  end
end
