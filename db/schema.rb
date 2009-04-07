# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090403161045) do

  create_table "members", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.string   "username"
    t.string   "hashed_password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members_organizations", :id => false, :force => true do |t|
    t.integer "member_id"
    t.integer "organization_id"
  end

  create_table "members_roles", :id => false, :force => true do |t|
    t.integer "member_id"
    t.integer "role_id"
  end

  create_table "members_teams", :id => false, :force => true do |t|
    t.integer "member_id"
    t.integer "team_id"
  end

  create_table "nametags", :force => true do |t|
    t.string   "name"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "relative_position_x"
    t.integer  "relative_position_y"
    t.integer  "member_id"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "portraits", :force => true do |t|
    t.integer  "member_id"
    t.integer  "parent_id"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id", :default => 0
  end

  create_table "projects_teams", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "team_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statustags", :force => true do |t|
    t.string   "status"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "color"
    t.integer  "relative_position_x"
    t.integer  "relative_position_y"
  end

  create_table "stories", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.integer  "priority"
    t.integer  "size"
    t.text     "how_to_demo"
    t.text     "requirement"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",      :default => "not_started"
    t.string   "realid"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.integer  "story_id"
    t.text     "description"
    t.string   "status",              :default => "not_started"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "relative_position_x"
    t.integer  "relative_position_y"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
