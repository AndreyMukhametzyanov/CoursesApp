class AddShortDescriptionToCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :short_description, :string
  end
end
