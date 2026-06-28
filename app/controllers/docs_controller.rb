class DocsController < ApplicationController
  before_action :require_login

  def index
    @project = Project.find(params[:project_id])
    @notes = @project.notes.roots.includes(:children, :author).order(:position, :created_at)
  end

  def show
    @note = Note.find(params[:id])
    @project = @note.project
    @comments = @note.comments.includes(:author).order(created_at: :asc)
    @children = @note.children.includes(:author).order(:position, :created_at)
    
    # Breadcrumb navigation
    @breadcrumbs = @note.ancestors
  end

  def new
    @project = Project.find(params[:project_id])
    @note = @project.notes.new(parent_id: params[:parent_id])
    @parent = @note.parent if @note.parent_id
  end

  def create
    @project = Project.find(params[:project_id])
    @note = @project.notes.new(note_params)
    @note.author = current_user

    if @note.save
      respond_to do |format|
        format.html { redirect_to doc_path(@note), notice: "Page created." }
        format.turbo_stream
      end
    else
      @parent = @note.parent if @note.parent_id
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @note = Note.find(params[:id])
    @project = @note.project
  end

  def update
    @note = Note.find(params[:id])
    @project = @note.project

    if @note.update(note_params)
      respond_to do |format|
        format.html { redirect_to doc_path(@note), notice: "Page updated." }
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @project = @note.project
    @note.destroy

    respond_to do |format|
      format.html { redirect_to project_docs_path(@project), notice: "Page deleted." }
      format.turbo_stream
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :body, :parent_id, :position, :published)
  end
end
