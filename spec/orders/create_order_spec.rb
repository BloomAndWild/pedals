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
        quote: 14_097,
        senderName: 'Gandalf',
        senderContact: '07700900776',
        receiverName: 'Elrond',
        receiverContact: '02079460683',
        description: 'The One Ring',
        specialInstructions: 'Package weight fluctuates'
      }
    end

    context 'with valid payload' do
      it 'returns valid response' do
        VCR.use_cassette('valid_create_order_request') do
          response = described_class.new(
            payload: payload
          ).execute
          expect(response.code).to eq(201)
          expect(response.body[:status]).to eq('available')
          expect(response.body[:senderName]).to eq('Gandalf')
          expect(response.body[:receiverName]).to eq('Elrond')
          expect(response.body[:id]).not_to be_nil
        end
      end
    end

    context 'with invalid payload' do
      context 'When senderName is empty' do
        let(:error_response_json) do
          { "field" => "senderName", "message" => "The name of the person sending the package (senderName) is required" }
        end

        it 'raises an exception' do
          payload[:senderName] = ''
          expect do
            VCR.use_cassette('create_order_request_with_empty_sender_name_payload') do
              described_class.new(payload: payload).execute
            rescue Pedals::Errors::ResponseError => e
              expect(e.status).to eq 422
              expect(JSON.parse(e.body)).to eq error_response_json
              raise e
            end
          end.to raise_exception(Pedals::Errors::ResponseError)
        end
      end

      context 'When receiverName is empty' do
        let(:error_response_json) do
          { "field" => "receiverName", "message" => "The name of the person receiving the package (receiverName) is required" }
        end

        it 'raises an exception' do
          payload[:receiverName] = ''
          expect do
            VCR.use_cassette('create_order_request_with_empty_receiver_name_payload') do
              described_class.new(payload: payload).execute
            rescue Pedals::Errors::ResponseError => e
              expect(e.status).to eq 422
              expect(JSON.parse(e.body)).to eq error_response_json
              raise e
            end
          end.to raise_exception(Pedals::Errors::ResponseError)
        end
      end

      context 'When receiverContact is empty' do
        let(:error_response_json) do
          { "field" => "receiverContact", "message" => "The phone number of the person receiving the package (receiverContact) is required" }
        end

        it 'raises an exception' do
          payload[:receiverContact] = ''
          expect do
            VCR.use_cassette('create_order_request_with_empty_receiver_contact_payload') do
              described_class.new(payload: payload).execute
            rescue Pedals::Errors::ResponseError => e
              expect(e.status).to eq 422
              expect(JSON.parse(e.body)).to eq error_response_json
              raise e
            end
          end.to raise_exception(Pedals::Errors::ResponseError)
        end
      end

      context 'When description is empty' do
        let(:error_response_json) do
          { "field" => "description", "message" => "A description of the items being delivered (description) is required" }
        end

        it 'raises an exception' do
          payload[:description] = ''
          expect do
            VCR.use_cassette('create_order_request_with_empty_description_payload') do
              described_class.new(payload: payload).execute
            rescue Pedals::Errors::ResponseError => e
              expect(e.status).to eq 422
              expect(JSON.parse(e.body)).to eq error_response_json
              raise e
            end
          end.to raise_exception(Pedals::Errors::ResponseError)
        end
      end
    end
  end
end
