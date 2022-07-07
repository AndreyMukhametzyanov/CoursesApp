# frozen_string_literal: true

# == Schema Information
#
# Table name: user_projects
#
#  id               :bigint           not null, primary key
#  complete         :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  final_project_id :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_user_projects_on_final_project_id  (final_project_id)
#  index_user_projects_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (final_project_id => final_projects.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe UserProject, type: :model do
  subject { build(:user_project) }

  describe 'associations' do
    it { is_expected.to belong_to(:final_project) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:replies) }
  end
end
