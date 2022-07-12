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

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:final_project_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:final_project) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:replies) }
  end

  describe 'custom validation' do
    let(:user) { create :user }
    let(:student) { create :user }
    let(:course) { create :course, author: user, students: [student] }
    let(:final_project) { create :final_project, course: course }

    context 'when user is owner' do
      let(:error_msg) do
        I18n.t('activerecord.errors.models.user_project.attributes.final_project.can_not_create_user_project')
      end
      let(:user_project) { build :user_project, final_project: final_project, user: user }

      before { user_project.save }

      it 'is not create model' do
        expect(user_project.errors.messages[:final_project].to_sentence).to eq(error_msg)
      end
    end
  end
end
