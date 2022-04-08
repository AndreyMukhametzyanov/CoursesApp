class AddDoubleUniqIndexForOrder < ActiveRecord::Migration[6.1]
  def change
    add_index :orders, [:course_id, :user_id], unique: true
  end
end
