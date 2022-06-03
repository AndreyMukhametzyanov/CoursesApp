# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe ExaminationsController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe '#show' do

  end

end
