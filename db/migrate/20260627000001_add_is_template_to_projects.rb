class AddIsTemplateToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :is_template, :boolean, default: false, null: false
  end
end
