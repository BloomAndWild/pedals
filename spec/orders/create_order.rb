# frozen_string_literal: true

require 'spec_helper'
describe Pedals::Orders::CreateOrder do
  describe '#execute' do
    before do
      configure_client
    end
    let(:config) { Pedals::Client.config }
    let(:payload) do
      {
        "quote": 13_509,
        "senderName": 'Gandalf',
        "senderContact": '07700900776',
        "receiverName": 'Elrond',
        "receiverContact": '02079460683',
        "description": 'The One Ring',
        "specialInstructions": 'Package weight fluctuates'
      }
    end
    context 'with valid payload' do
      it 'returns valid response' do
        VCR.use_cassette('valid_create_order_request') do
          response = described_class.new(
            payload: payload
          ).execute
          expect(response.code).to eq(201)
          expect(JSON.parse(response.body)['status']).to eq('available')
          expect(JSON.parse(response.body)['senderName']).to eq('Gandalf')
          expect(JSON.parse(response.body)['receiverName']).to eq('Elrond')
          expect(JSON.parse(response.body)['id']).not_to be_nil
        end
      end
    end
    context 'with invalid payload' do
      context 'When senderName is empty' do
        it 'returns error message' do
          payload[:senderName] = ''
          VCR.use_cassette('create_order_request_with_empty_sender_name_payload') do
            response = described_class.new(
              payload: payload
            ).execute
            expect(response.code).to eq(422)
            expect(JSON.parse(response)['field']).to eq('senderName')
            expect(JSON.parse(response)['message']).to eq('The name of the person sending the package (senderName) is required')
          end
        end
      end
      context 'When receiverName is empty' do
        it 'returns error message' do
          payload[:receiverName] = ''
          VCR.use_cassette('create_order_request_with_empty_receiver_name_payload') do
            response = described_class.new(
              payload: payload
            ).execute
            expect(response.code).to eq(422)
            expect(JSON.parse(response)['field']).to eq('receiverName')
            expect(JSON.parse(response)['message']).to eq('The name of the person receiving the package (receiverName) is required')
          end
        end
      end
      context 'When receiverContact & description is empty' do
        it 'returns error message for receiverContact ' do
          payload[:receiverContact] = ''
          VCR.use_cassette('create_order_request_with_empty_receiverContact_payload') do
            response = described_class.new(
              payload: payload
            ).execute
            expect(response.code).to eq(422)
            expect(JSON.parse(response)['field']).to eq('receiverContact')
            expect(JSON.parse(response)['message']).to eq('The phone number of the person receiving the package (receiverContact) is required')
          end
        end

        it 'returns error message for empty description ' do
          payload[:description] = ''
          VCR.use_cassette('create_quote_request_with_empty_description_payload') do
            response = described_class.new(
              payload: payload
            ).execute
            expect(response.code).to eq(422)
            expect(JSON.parse(response)['field']).to eq('description')
            expect(JSON.parse(response)['message']).to eq('A description of the items being delivered (description) is required')
          end
        end
      end
    end
  end
end
