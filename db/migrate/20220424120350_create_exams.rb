class CreateExams < ActiveRecord::Migration[6.1]
  def change
    create_table :exams do |t|
      t.string :title
      t.string :description
      t.integer :attempts_number
      t.integer :attempts_time
      t.belongs_to :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
