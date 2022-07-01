class CreateFinalProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :final_projects do |t|
      t.text :description
      t.text :short_description
      t.integer :execution_days
      t.belongs_to :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
