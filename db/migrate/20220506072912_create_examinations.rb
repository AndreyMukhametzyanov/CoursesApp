class CreateExaminations < ActiveRecord::Migration[6.1]
  def change
    create_table :examinations do |t|
      t.integer :passage_time
      t.boolean :pass_exam
      t.integer :correct_answers
      t.integer :percentage_passing
      t.belongs_to :exam, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
