class AddUniqIndexColumnForCourse < ActiveRecord::Migration[6.1]
  def change
    add_index :courses, :name, unique: true
  end
end
