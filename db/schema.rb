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

ActiveRecord::Schema.define(version: 2022_07_01_132000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.string "body"
    t.boolean "correct_answer", default: false
    t.bigint "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "description"
    t.integer "level"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "youtube_video_id"
    t.string "short_description"
    t.index ["name"], name: "index_courses_on_name", unique: true
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "examinations", force: :cascade do |t|
    t.integer "passage_time", default: 0
    t.boolean "passed_exam", default: false
    t.boolean "finished_exam", default: false
    t.integer "number_of_questions", default: 0
    t.integer "correct_answers", default: 0
    t.integer "percentage_passing", default: 0
    t.bigint "exam_id", null: false
    t.bigint "user_id", null: false
    t.bigint "next_question_id"
    t.bigint "current_question_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["current_question_id"], name: "index_examinations_on_current_question_id"
    t.index ["exam_id"], name: "index_examinations_on_exam_id"
    t.index ["next_question_id"], name: "index_examinations_on_next_question_id"
    t.index ["user_id"], name: "index_examinations_on_user_id"
  end

  create_table "exams", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "attempts_count"
    t.integer "attempt_time"
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_exams_on_course_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text "body"
    t.integer "grade"
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_feedbacks_on_course_id"
    t.index ["user_id", "course_id"], name: "index_feedback_on_course_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "final_projects", force: :cascade do |t|
    t.text "description"
    t.text "short_description"
    t.integer "execution_days"
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_final_projects_on_course_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.text "youtube_video_id"
    t.text "content"
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.integer "order_factor"
    t.index ["course_id"], name: "index_lessons_on_course_id"
  end

  create_table "links", force: :cascade do |t|
    t.string "address", null: false
    t.bigint "lesson_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lesson_id"], name: "index_links_on_lesson_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id", "user_id"], name: "index_orders_on_course_id_and_user_id", unique: true
    t.index ["course_id"], name: "index_orders_on_course_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.bigint "exam_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exam_id"], name: "index_questions_on_exam_id"
  end

  create_table "user_projects", force: :cascade do |t|
    t.boolean "complete", default: false
    t.bigint "final_project_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["final_project_id"], name: "index_user_projects_on_final_project_id"
    t.index ["user_id"], name: "index_user_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name"
    t.date "date_of_birth"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "questions"
  add_foreign_key "comments", "users"
  add_foreign_key "examinations", "exams"
  add_foreign_key "examinations", "questions", column: "current_question_id"
  add_foreign_key "examinations", "questions", column: "next_question_id"
  add_foreign_key "examinations", "users"
  add_foreign_key "exams", "courses"
  add_foreign_key "feedbacks", "courses"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "final_projects", "courses"
  add_foreign_key "lessons", "courses"
  add_foreign_key "questions", "exams"
  add_foreign_key "user_projects", "final_projects"
  add_foreign_key "user_projects", "users"
end
