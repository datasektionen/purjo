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

ActiveRecord::Schema.define(:version => 20100708120723) do

  create_table "articles", :force => true do |t|
    t.integer  "blog_id"
    t.string   "title"
    t.text     "content"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.string   "name"
    t.string   "perma_name"
    t.string   "layout"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chapter_posts", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.float    "hp"
    t.string   "level"
    t.string   "handbook_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "course_home_page"
  end

  create_table "cvs", :force => true do |t|
    t.string   "name"
    t.string   "mail"
    t.string   "phone"
    t.integer  "birth_year"
    t.integer  "study_start"
    t.integer  "planned_exam"
    t.string   "orientation"
    t.text     "personal"
    t.text     "ambitions"
    t.text     "employment"
    t.text     "education"
    t.text     "other_commitments"
    t.text     "language_skills"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "other"
    t.text     "it_skills"
    t.boolean  "done"
    t.integer  "travel_year_id"
    t.string   "language"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "election_events", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "election_events", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "file_nodes", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "size"
    t.string   "resource_content_type"
    t.string   "resource_file_name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "resource_file_size"
    t.datetime "resource_updated_at"
  end

  create_table "functionaries", :force => true do |t|
    t.integer  "person_id"
    t.integer  "chapter_post_id"
    t.date     "active_from"
    t.date     "active_to"
    t.boolean  "postponed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_ads", :force => true do |t|
    t.string   "title"
    t.string   "company"
    t.text     "description"
    t.integer  "created_by_id"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "part_time"
    t.boolean  "full_time"
    t.boolean  "thesis"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kth_accounts", :force => true do |t|
    t.string   "ugid"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kth_accounts", ["ugid"], :name => "index_kth_accounts_on_ugid", :unique => true

  create_table "list_entries", :force => true do |t|
    t.integer  "person_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "list_id"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "person_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "morklaggnings", :force => true do |t|
    t.string   "username"
    t.string   "drifvarname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsletter_sections", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "newsletter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsletter_subscriptions", :force => true do |t|
    t.integer  "person_id"
    t.string   "state"
    t.datetime "subscribed_at"
    t.datetime "cancelled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsletters", :force => true do |t|
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsletters", :force => true do |t|
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "campaign_id"
  end

  create_table "noises", :force => true do |t|
    t.integer  "post_id"
    t.integer  "person_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nominees", :force => true do |t|
    t.integer  "person_id"
    t.integer  "election_event_id"
    t.integer  "chapter_post_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "cell_phone_number"
    t.string   "kth_ugid"
    t.string   "kth_username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "phone"
    t.string   "homepage"
    t.string   "nickname"
    t.integer  "startyear"
    t.string   "personalemail"
    t.string   "msn"
    t.string   "xmpp"
    t.text     "serialized_my_settings"
    t.text     "serialized_features"
    t.boolean  "has_chosen_settings",    :default => false, :null => false
  end

  add_index "people", ["kth_ugid"], :name => "index_people_on_kth_ugid", :unique => true
  add_index "people", ["kth_username"], :name => "index_people_on_kth_username", :unique => true

  create_table "posts", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.boolean  "news_post",     :default => false
    t.datetime "expires_at"
    t.boolean  "calendar_post", :default => false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "all_day"
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "bumped_at"
    t.boolean  "sticky"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.string   "username_nada"
    t.string   "username_kth"
    t.string   "sektion"
    t.string   "adress"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "uid"
    t.string   "homedir"
    t.string   "gender"
    t.string   "phone_home"
    t.string   "phone_mobile"
  end

  create_table "system_permissions", :force => true do |t|
    t.integer  "group_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "text_nodes", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.string   "url"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version"
    t.string   "custom_layout"
  end

  create_table "travel_years", :force => true do |t|
    t.integer  "year"
    t.string   "layout"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "serialized_project_members"
    t.text     "serialized_company_users"
  end

end
