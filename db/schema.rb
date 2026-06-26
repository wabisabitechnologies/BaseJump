# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_27_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.text "body", null: false
    t.bigint "commentable_id", null: false
    t.string "commentable_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
  end

  create_table "companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "image_url"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "end_date", null: false
    t.bigint "project_id", null: false
    t.string "start_date", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "video_link"
    t.index ["author_id"], name: "index_events_on_author_id"
    t.index ["project_id"], name: "index_events_on_project_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "author_id"
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.string "message_type"
    t.bigint "project_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_messages_on_author_id"
    t.index ["project_id"], name: "index_messages_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "admin_id"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.boolean "is_template", default: false, null: false
    t.string "name", null: false
    t.string "project_type", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_projects_on_admin_id"
    t.index ["company_id"], name: "index_projects_on_company_id"
  end

  create_table "subtasks", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.datetime "created_at", null: false
    t.boolean "done", default: false, null: false
    t.bigint "parent_todo_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_subtasks_on_author_id"
    t.index ["parent_todo_id"], name: "index_subtasks_on_parent_todo_id"
  end

  create_table "todo_lists", force: :cascade do |t|
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "project_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_todo_lists_on_author_id"
    t.index ["project_id"], name: "index_todo_lists_on_project_id"
  end

  create_table "todos", force: :cascade do |t|
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "done", default: false, null: false
    t.datetime "due_date"
    t.string "title", null: false
    t.bigint "todo_list_id"
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_todos_on_author_id"
    t.index ["todo_list_id"], name: "index_todos_on_todo_list_id"
  end

  create_table "user_projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "project_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["project_id"], name: "index_user_projects_on_project_id"
    t.index ["user_id", "project_id"], name: "index_user_projects_on_user_id_and_project_id", unique: true
    t.index ["user_id"], name: "index_user_projects_on_user_id"
  end

  create_table "user_todos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "todo_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["todo_id"], name: "index_user_todos_on_todo_id"
    t.index ["user_id", "todo_id"], name: "index_user_todos_on_user_id_and_todo_id", unique: true
    t.index ["user_id"], name: "index_user_todos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin"
    t.string "avatar_url"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "job_title"
    t.string "name", null: false
    t.boolean "owner"
    t.string "password_digest", null: false
    t.string "session_token", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["session_token"], name: "index_users_on_session_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "comments", "users", column: "author_id"
  add_foreign_key "events", "projects"
  add_foreign_key "events", "users", column: "author_id"
  add_foreign_key "messages", "projects"
  add_foreign_key "messages", "users", column: "author_id"
  add_foreign_key "projects", "companies"
  add_foreign_key "projects", "users", column: "admin_id"
  add_foreign_key "subtasks", "todos", column: "parent_todo_id"
  add_foreign_key "subtasks", "users", column: "author_id"
  add_foreign_key "todo_lists", "projects"
  add_foreign_key "todo_lists", "users", column: "author_id"
  add_foreign_key "todos", "todo_lists"
  add_foreign_key "todos", "users", column: "author_id"
  add_foreign_key "user_projects", "projects"
  add_foreign_key "user_projects", "users"
  add_foreign_key "user_todos", "todos"
  add_foreign_key "user_todos", "users"
  add_foreign_key "users", "companies"
end
