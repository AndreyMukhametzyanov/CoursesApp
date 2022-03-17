class AddOrderFactorToLesson < ActiveRecord::Migration[6.1]
  def change
    add_column :lessons, :order_factor, :integer
    add_index :lessons, :order_factor, unique: true
  end
end
