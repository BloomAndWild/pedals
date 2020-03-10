# frozen_string_literal: true

require 'spec_helper'
describe Pedals::Quote::CreateQuote do
  describe '#execute' do
    before do
      configure_client
    end
    let(:config) { Pedals::Client.config }
    let(:payload) do
      {
        "pickup": {
          "address": '110 Hampstead Road',
          "postcode": 'NW1 2LS',
          "lat": 51.5284878,
          "lng": -0.1290927
        },
        "dropoff": {
          "address": 'The British Museum',
          "postcode": 'WC1B 3DG',
          "lat": 51.5191683,
          "lng": -0.1290927
        },
        "timing": 'flexible',
        "earliestDeliveryTime": '2016-06-12T11:00:00Z',
        "latestDeliveryTime": '2016-06-12T12:00:00Z'
      }
    end
    context 'with valid payload' do
      it 'returns valid response' do
        VCR.use_cassette('valid_create_quote_request') do
          response = described_class.new(
            payload: payload
          ).execute
          expect(response.code).to eq(201)
          expect(response.body[:id]).not_to be_nil
          expect(response.body[:id]).to eq(14_097)
        end
      end
    end
    context 'with invalid payload' do
      context 'When pickup location is empty' do
        it 'raises an exception' do
          payload[:pickup] = {}
          VCR.use_cassette('create_quote_request_with_invalid_payload') do
            expect do
              described_class.new(payload: payload).execute
            end.to raise_exception(Pedals::Errors::ResponseError, "Sorry, we couldn't find a route from the pick-up to the drop-off")
          end
        end
      end
      context 'When dropoff location is empty' do
        it 'raises an exception' do
          payload[:dropoff] = {}
          VCR.use_cassette('create_quote_request_with_empty_dropoff_payload') do
            expect do
              described_class.new(payload: payload).execute
            end.to raise_exception(Pedals::Errors::ResponseError, "Sorry, we couldn't find a route from the pick-up to the drop-off")
          end
        end
      end
      context 'When earliestDeliveryTime or latestDeliveryTime are empty' do
        it 'raises and exception' do
          payload[:earliestDeliveryTime] = {}
          VCR.use_cassette('create_quote_request_with_empty_earliestDeliveryTime_payload') do
            expect do
              described_class.new(payload: payload).execute
            end.to raise_exception(Pedals::Errors::ResponseError, 'We need to know the earliest time the package can be delivered.')
          end
        end

        it 'raises and exception' do
          payload[:latestDeliveryTime] = {}
          VCR.use_cassette('create_quote_request_with_empty_latestDeliveryTime_payload') do
            expect do
              described_class.new(payload: payload).execute
            end.to raise_exception(Pedals::Errors::ResponseError, 'We need to know the latest time the package can be delivered.')
          end
        end
      end
    end
  end
end
