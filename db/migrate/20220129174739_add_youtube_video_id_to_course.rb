class AddYoutubeVideoIdToCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :youtube_video_id, :text
  end
end
