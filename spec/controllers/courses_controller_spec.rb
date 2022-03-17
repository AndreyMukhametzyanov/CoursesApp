require 'rails_helper'
require 'spec_helper'

RSpec.describe CoursesController, type: :controller do
  describe '#index' do
    let!(:courses) { create_list :course, 3 }

    before { get :index }

    it 'should returns correct renders for #index' do
      expect(response).to have_http_status(200)
      expect(response).to render_template('index')
    end
  end

  describe '#create' do
  end

  describe '#edit' do
  end

  describe '#update' do
  end

  describe '#promo' do
  end

  describe '#start' do
  end
end
