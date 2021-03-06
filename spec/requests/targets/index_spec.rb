# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /targets', type: :request do
  let(:user) { create :user }

  subject do
    get '/targets', headers: headers
    data
  end

  context 'user with targets' do
    before do
      create_list :target, 3, user: user
    end

    it 'returns 3 targets' do
      expect(subject.size).to eq 3
    end
  end

  context 'user without targets' do
    it 'returns an empty array' do
      expect(subject.size).to eq 0
    end
  end
end
