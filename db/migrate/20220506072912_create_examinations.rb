class CreateExaminations < ActiveRecord::Migration[6.1]
  def change
    create_table :examinations do |t|
      t.integer :passage_time, default: 0
      t.boolean :passed_exam, default: false
      t.boolean :finished_exam, default: false
      t.integer :number_of_questions, default: 0
      t.integer :correct_answers, default: 0
      t.integer :percentage_passing, default: 0
      t.belongs_to :exam, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :next_question, foreign_key: { to_table: :questions }
      t.belongs_to :current_question, foreign_key: { to_table: :questions }

      t.timestamps
    end
  end
end
