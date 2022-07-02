class CreateReplies < ActiveRecord::Migration[6.1]
  def change
    create_table :replies do |t|
      t.text :user_reply
      t.text :teacher_comment
      t.integer :status
      t.belongs_to :user_project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
