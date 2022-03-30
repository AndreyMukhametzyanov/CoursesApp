class AddTitleToLesson < ActiveRecord::Migration[6.1]
  def change
    add_column :lessons, :title, :string
  end
end
