class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.text :body
      t.integer :grade
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :course, null: false, foreign_key: true
      t.index ["user_id", "course_id"], name: "index_feedback_on_course_id_and_user_id", unique: true

      t.timestamps
    end
  end
end
