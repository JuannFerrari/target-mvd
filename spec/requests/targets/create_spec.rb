# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /targets', type: :request do
  let(:area_length) { rand 1000 }
  let(:lat) { Faker::Address.latitude }
  let(:lng) { Faker::Address.longitude }
  let(:title) { Faker::Name.name }
  let(:topic) { create :topic }
  let(:user) { create :user }

  let(:body) do
    {
      'data' => {
        'type' => 'target',
        'attributes' => {
          'area_length' => area_length,
          'lat' => lat,
          'lng' => lng,
          'title' => title
        },
        'relationships' => {
          'topic' => {
            'data' => {
              'type' => 'topic',
              'id' => topic.id
            }
          }
        }
      }
    }.to_json
  end

  subject do
    post '/targets', params: body, headers: headers
    data
  end

  context 'valid params' do
    it 'creates the target correctly' do
      expect { subject }.to change { Target.count }.by 1
    end

    it 'has the correct lat' do
      expect(subject['attributes']['lat']).to eq lat
    end

    it 'has the correct lng' do
      expect(subject['attributes']['lng']).to eq lng
    end

    it 'has the correct title' do
      expect(subject['attributes']['title']).to eq title
    end

    it 'has the correct area length' do
      expect(subject['attributes']['areaLength']).to eq area_length
    end

    it 'enqueues a broadcast job' do
      expect { subject }.to have_enqueued_job
    end
  end

  context 'missing params' do
    let(:body) { nil }

    before { subject }

    it 'returns an error message' do
      expect(errors).to include 'A required param is missing'
    end
  end

  context 'missing title param' do
    let(:title) { nil }

    before { subject }

    it 'returns the error message' do
      expect(errors).to include "Title can't be blank"
    end
  end
end
