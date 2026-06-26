class ProjectTemplatesController < ApplicationController
  before_action :require_login

  def index
    @templates = Project.where(is_template: true).includes(:todo_lists, :messages, :events)
  end

  def create
    @project = Project.find(params[:id])
    
    # Create a template from an existing project
    template = Project.create!(
      name: "#{@project.name} Template",
      description: @project.description,
      project_type: @project.project_type,
      company: current_user.company,
      admin: current_user,
      is_template: true
    )

    # Copy todo lists
    @project.todo_lists.each do |tl|
      new_tl = template.todo_lists.create!(
        title: tl.title,
        description: tl.description,
        author: current_user
      )
      
      # Copy todos (without done status)
      tl.todos.each do |todo|
        new_tl.todos.create!(
          title: todo.title,
          description: todo.description,
          author: current_user
        )
      end
    end

    redirect_to templates_path, notice: "Template created from #{@project.name}"
  end

  def use_template
    template = Project.find(params[:id])
    
    # Create a new project from template
    project = Project.create!(
      name: "#{template.name} (Copy)",
      description: template.description,
      project_type: template.project_type,
      company: current_user.company,
      admin: current_user
    )

    UserProject.create(user: current_user, project: project)

    # Copy todo lists
    template.todo_lists.each do |tl|
      new_tl = project.todo_lists.create!(
        title: tl.title,
        description: tl.description,
        author: current_user
      )
      
      # Copy todos
      tl.todos.each do |todo|
        new_tl.todos.create!(
          title: todo.title,
          description: todo.description,
          author: current_user
        )
      end
    end

    redirect_to project_path(project), notice: "Project created from template"
  end
end
