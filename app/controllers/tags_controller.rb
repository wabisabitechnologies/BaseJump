class TagsController < ApplicationController
  before_action :require_login

  def index
    @tags = Tag.all.order(:name)
  end

  def create
    @tag = Tag.new(tag_params)
    
    if @tag.save
      respond_to do |format|
        format.html { redirect_back(fallback_location: home_path) }
        format.turbo_stream
      end
    else
      redirect_back(fallback_location: home_path, alert: "Tag could not be created.")
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    
    respond_to do |format|
      format.html { redirect_to tags_path, notice: "Tag deleted." }
      format.turbo_stream
    end
  end

  def tag_item
    @item = find_taggable
    @tag = Tag.find_or_create_by(name: params[:tag_name])
    
    unless @item.tags.include?(@tag)
      @item.tags << @tag
    end
    
    redirect_back(fallback_location: home_path)
  end

  def untag_item
    @item = find_taggable
    @tag = Tag.find(params[:tag_id])
    
    @item.tags.delete(@tag)
    
    redirect_back(fallback_location: home_path)
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :color)
  end

  def find_taggable
    if params[:message_id]
      Message.find(params[:message_id])
    elsif params[:todo_id]
      Todo.find(params[:todo_id])
    elsif params[:event_id]
      Event.find(params[:event_id])
    elsif params[:project_id]
      Project.find(params[:project_id])
    end
  end
end
