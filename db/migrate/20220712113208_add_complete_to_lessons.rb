class AddCompleteToLessons < ActiveRecord::Migration[6.1]
  def change
    add_column :lessons, :complete, :boolean, default: false
  end
end
