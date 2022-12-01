class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :lesson, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :kind
      t.timestamps
    end

    add_index :votes, [:user_id, :lesson_id], unique: true
  end
end
