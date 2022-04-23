# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  subject(:link) { build(:link) }

  describe 'associations' do
    it { is_expected.to belong_to(:lesson) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:address) }
  end

  describe 'custom validation' do
    context 'when link is correct' do
      it 'is valid' do
        expect(link).to be_valid
      end
    end

    context 'when link is not correct' do
      let(:error_message) { I18n.t('activerecord.errors.models.link.attributes.address.is_not_uri') }

      before { link.address = 'wrong' }

      it 'is not valid' do
        expect(link).not_to be_valid
        expect(link.errors.messages[:address].to_sentence).to eq(error_message)
      end
    end

    context 'when link is blank' do
      before { link.address = nil }

      it 'is not valid for nil link' do
        expect(link).not_to be_valid
      end
    end
  end
end
