class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :address, null: false
      t.belongs_to :lesson
      t.timestamps
    end
  end
end
