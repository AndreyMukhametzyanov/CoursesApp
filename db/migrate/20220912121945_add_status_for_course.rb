class AddStatusForCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :status, :text
  end
end
