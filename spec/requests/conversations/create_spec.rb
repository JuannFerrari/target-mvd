# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /conversations', type: :request do
  let(:lat) { user.targets.first.lat }
  let(:lng) { user.targets.first.lng }
  let(:target) { create :target, lat: lat, lng: lng, topic: topic }
  let(:topic) { user.targets.first.topic }
  let(:user) { create :user_with_targets, targets_count: 1 }

  let(:body) do
    {
      'data' => {
        'type' => 'conversation',
        'attributes' => {},
        'relationships' => {
          'target' => {
            'data' => {
              'type' => 'target',
              'id' => target.id
            }
          }
        }
      }
    }.to_json
  end

  subject { post '/conversations', params: body, headers: headers }

  context 'valid params' do
    context 'nonexistent conversation' do
      it 'creates a conversation' do
        expect { subject }.to change { Conversation.count }.by 1
      end
    end

    context 'with an already started conversation' do
      before do
        create :conversation, target: target, initiator: user
        subject
      end

      it 'returns an error' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with a target the user owns' do
      let(:target) { user.targets.first }

      before { subject }

      it 'returns an error' do
        expect(errors).to include 'Target must not belong to the initiator'
      end
    end
  end

  context 'missing body' do
    let(:body) do
      {}
    end

    before { subject }

    it 'returns an error message' do
      expect(errors).to include 'A required param is missing'
    end

    it 'does not return a successful response' do
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
