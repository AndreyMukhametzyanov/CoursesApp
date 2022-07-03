class CreateUserProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :user_projects do |t|
      t.boolean :complete, default: false
      t.belongs_to :final_project, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.index ["final_project_id", "user_id"], name: "index_user_project_final_project_id_and_user_id", unique: true

      t.timestamps
    end
  end
end
