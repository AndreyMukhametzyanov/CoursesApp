class DeleteUniqIndexLessons < ActiveRecord::Migration[6.1]
  def change
    remove_index :lessons, name: "index_lessons_on_order_factor"
  end
end
