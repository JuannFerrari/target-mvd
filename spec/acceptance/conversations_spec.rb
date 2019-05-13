# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Conversations' do
  header 'access-token', :access_token_header
  header 'client', :client_header
  header 'uid', :uid_header

  let(:conversation) { create :conversation }
  let(:conversation_with_messages) do
    create :conversation_with_messages, initiator: conversation.initiator,
                                        target: conversation.target
  end
  let(:user) { conversation.initiator }

  with_conversation_response = lambda {
    with_options scope: :conversation, required: true do
      response_field :messages, 'Array of messages'
      response_field :target, 'Target object'
      response_field :initiator, 'Initiator user'
      response_field :unread, 'Unread indicator for the current user'
    end
  }

  before { create_list :conversation, 3, initiator: user }

  route '/conversations', 'Conversations collection' do
    post 'Create' do
      with_conversation_response.call

      with_options scope: :conversation, required: true do
        attribute :target_id, 'Target associated to the conversation'
        attribute :initiator_id, 'ID of the user whom initiated the conversation'
      end

      let(:target_id) { conversation.target_id }
      let(:initiator_id) { conversation.initiator_id }

      example 'Ok' do
        do_request

        expect(status).to eq 201
      end
    end

    get 'Index' do
      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end

  route '/conversations/:id', 'Conversation member' do
    let(:id) { conversation_with_messages.id }

    get 'Show' do
      with_conversation_response.call

      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end

    put 'Update' do
      with_conversation_response.call

      with_options scope: :conversation, required: true do
        attribute :unread, 'Flag to mark the conversation as unread'
      end

      let(:unread) { false }

      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end
end
