# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Compatible targets' do
  header 'access-token', :access_token_header
  header 'client', :client_header
  header 'uid', :uid_header

  let(:user) { create :user }

  before do
    lat = Faker::Address.latitude
    lng = Faker::Address.longitude
    target = create :target, user: user, lat: lat, lng: lng, area_length: 1000
    create :target, topic: target.topic, area_length: 2000, lat: lat + 0.01, lng: lng + 0.01
  end

  route '/compatible_targets', 'Compatible targets collection' do
    get 'Index' do
      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end
end