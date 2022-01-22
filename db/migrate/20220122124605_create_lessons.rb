class CreateLessons < ActiveRecord::Migration[6.1]
  def change
    create_table :lessons do |t|
      t.text :youtube_video_id
      t.text :content
      t.belongs_to :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
