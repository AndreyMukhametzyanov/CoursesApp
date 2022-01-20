class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.belongs_to :user
      t.string :name
      t.string :description
      t.integer :level

      t.timestamps
    end
  end
end
