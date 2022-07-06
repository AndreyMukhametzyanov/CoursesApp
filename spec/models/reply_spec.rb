# == Schema Information
#
# Table name: replies
#
#  id              :bigint           not null, primary key
#  status          :text
#  teacher_comment :text
#  user_reply      :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_project_id :bigint           not null
#
# Indexes
#
#  index_replies_on_user_project_id  (user_project_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_project_id => user_projects.id)
#
require 'rails_helper'

RSpec.describe Reply, type: :model do
  subject { build(:reply) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_reply) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user_project) }
  end

  describe 'enum' do
    it { is_expected.to define_enum_for(:status).with_values({ verification: 0, rejected: 1, accepted: 2 }) }
  end
end
