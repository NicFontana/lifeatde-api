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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_09_06_092914) do

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "categories_projects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_categories_projects_on_category_id"
    t.index ["project_id", "category_id"], name: "index_categories_projects_on_project_id_and_category_id"
    t.index ["project_id"], name: "index_categories_projects_on_project_id"
  end

  create_table "categories_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_categories_users_on_category_id"
    t.index ["user_id", "category_id"], name: "index_categories_users_on_user_id_and_category_id"
    t.index ["user_id"], name: "index_categories_users_on_user_id"
  end

  create_table "courses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses_news", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "course_id"
    t.bigint "news_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "news_id"], name: "index_courses_news_on_course_id_and_news_id"
    t.index ["course_id"], name: "index_courses_news_on_course_id"
    t.index ["news_id"], name: "index_courses_news_on_news_id"
  end

  create_table "documents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "path", null: false
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_documents_on_project_id"
  end

  create_table "news", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_project_statuses_on_name", unique: true
  end

  create_table "projects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.text "results"
    t.bigint "project_status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_status_id"], name: "index_projects_on_project_status_id"
  end

  create_table "projects_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "user_id"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_projects_users_on_project_id"
    t.index ["user_id"], name: "index_projects_users_on_user_id"
  end

  create_table "study_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_study_groups_on_course_id"
    t.index ["user_id"], name: "index_study_groups_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.text "bio"
    t.date "birthday"
    t.string "phone"
    t.string "profile_picture_path"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_users_on_course_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "categories_projects", "categories", on_update: :cascade, on_delete: :cascade
  add_foreign_key "categories_projects", "projects", on_update: :cascade, on_delete: :cascade
  add_foreign_key "categories_users", "categories", on_update: :cascade, on_delete: :cascade
  add_foreign_key "categories_users", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "courses_news", "courses", on_update: :cascade, on_delete: :cascade
  add_foreign_key "courses_news", "news", on_update: :cascade, on_delete: :cascade
  add_foreign_key "documents", "projects", on_update: :cascade, on_delete: :cascade
  add_foreign_key "projects", "project_statuses", on_update: :cascade, on_delete: :nullify
  add_foreign_key "projects_users", "projects", on_update: :cascade, on_delete: :cascade
  add_foreign_key "projects_users", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "study_groups", "courses", on_update: :cascade, on_delete: :cascade
  add_foreign_key "study_groups", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "users", "courses", on_update: :cascade, on_delete: :nullify
end
