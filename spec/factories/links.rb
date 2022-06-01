# frozen_string_literal: true

# == Schema Information
#
# Table name: links
#
#  id         :bigint           not null, primary key
#  address    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lesson_id  :bigint
#
# Indexes
#
#  index_links_on_lesson_id  (lesson_id)
#
FactoryBot.define do
  factory :link do
    lesson
    address { 'https://github.com/AndreyMukhametzyanov' }
  end
end
