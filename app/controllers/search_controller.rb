class SearchController < ApplicationController
  before_action :require_login

  def index
    if params[:q].present?
      @query = params[:q]
      @messages = Message.search(@query).includes(:author, :project).limit(10)
      @todos = Todo.search(@query).includes(:author, :todo_list).limit(10)
      @events = Event.search(@query).includes(:author, :project).limit(10) if Event.respond_to?(:search)
    else
      @messages = []
      @todos = []
      @events = []
    end
  end
end
