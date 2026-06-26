class EverythingController < ApplicationController
  before_action :require_login

  def index
    @projects = current_user.projects.includes(:todo_lists, :messages, :events)
    
    # Get all todos assigned to current user
    @my_todos = current_user.assigned_todos
      .includes(todo_list: :project)
      .not_done
      .order(due_date: :asc, created_at: :desc)
    
    # Get all messages across user's projects
    @recent_messages = Message
      .where(project_id: @projects.pluck(:id))
      .includes(:author, :project)
      .order(created_at: :desc)
      .limit(20)
    
    # Get all events across user's projects
    @upcoming_events = Event
      .where(project_id: @projects.pluck(:id))
      .includes(:author, :project)
      .where("start_date >= ?", Date.today)
      .order(start_date: :asc)
      .limit(10)
    
    # Filter by type if params present
    case params[:filter]
    when "todos"
      @messages = []
      @events = []
    when "messages"
      @my_todos = []
      @events = []
    when "events"
      @my_todos = []
      @messages = []
    end
  end
end
