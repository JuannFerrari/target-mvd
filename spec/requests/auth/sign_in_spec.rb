# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /auth/sign_in', type: :request do
  let(:user) { create :user }
  let(:password) { 'P@55word' }
  let(:params) do
    {
      email: user.email,
      password: password
    }
  end

  subject { post '/auth/sign_in', params: params }

  before(:each) { subject }

  context 'valid user' do
    it 'allows me to log in' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'invalid user' do
    context 'inexistent user' do
      let(:user) { build :user }

      it "doesn't allow me to log in" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'wrong password' do
      let(:password) { '123456' }

      it "doesn't allow me to log in" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
