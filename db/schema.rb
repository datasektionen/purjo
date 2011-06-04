# This file is auto-generated from the current state of the database. Instead 
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your 
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100524093853) do

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

  create_table "travel_years", :force => true do |t|
    t.integer  "year"
    t.string   "layout"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "serialized_project_members"
    t.text     "serialized_company_users"
  end

end
