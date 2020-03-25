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
        pickup: {
          address: '110 Hampstead Road',
          postcode: 'NW1 2LS',
          lat: 51.5284878,
          lng: -0.1290927
        },
        dropoff: {
          address: 'The British Museum',
          postcode: 'WC1B 3DG',
          lat: 51.5191683,
          lng: -0.1290927
        },
        timing: 'flexible',
        earliestDeliveryTime: '2016-06-12T11:00:00Z',
        latestDeliveryTime: '2016-06-12T12:00:00Z'
      }
    end

    context 'with valid payload' do
      it 'returns valid response' do
        VCR.use_cassette('valid_create_quote_request') do
          response = described_class.new(
            payload: payload
          ).execute
          expect(response.code).to eq(201)
          expect(response.body[:id]).to eq(14_097)
        end
      end
    end

    context 'with invalid payload' do
      context 'When pickup or drop off locations are empty' do
        let(:error_response) do
          "{\"field\":null,\"message\":\"Sorry, we couldn't find a route from the pick-up to the drop-off\"}"
        end

        it 'raises an exception' do
          payload[:pickup] = {}
          expect do
            # check this vcr as the response is 401 unauthorised. add an extra spec for that case
            VCR.use_cassette('create_quote_request_with_empty_pickup_payload') do
              described_class.new(payload: payload).execute
            rescue Pedals::Errors::ResponseError => e
              expect(e.status).to eq 422
              expect(e.body).to eq error_response
              raise e
            end
          end.to raise_exception(Pedals::Errors::ResponseError)
        end

        it 'raises an exception' do
          payload[:dropoff] = {}
          expect do
            VCR.use_cassette('create_quote_request_with_empty_dropoff_payload') do
              described_class.new(payload: payload).execute
            rescue Pedals::Errors::ResponseError => e
              expect(e.status).to eq 422
              expect(e.body).to eq error_response
              raise e
            end
          end.to raise_exception(Pedals::Errors::ResponseError)
        end
      end

      context 'When earliestDeliveryTime or latestDeliveryTime are empty' do
        let(:earliest_error_response) do
          "{\"field\":\"earliestDeliveryTime\",\"message\":\"We need to know the earliest time the package can be delivered.\"}"
        end
        let(:latest_error_response) do
          "{\"field\":\"earliestDeliveryTime\",\"message\":\"We need to know the latest time the package can be delivered.\"}"
        end

        it 'raises and exception' do
          payload[:earliestDeliveryTime] = {}
          expect do
            VCR.use_cassette('create_quote_request_with_empty_earliestDeliveryTime_payload') do
              described_class.new(payload: payload).execute
            rescue Pedals::Errors::ResponseError => e
              expect(e.status).to eq 422
              expect(e.body).to eq earliest_error_response
              raise e
            end
          end.to raise_exception(Pedals::Errors::ResponseError)
        end

        it 'raises and exception' do
          payload[:latestDeliveryTime] = {}
          expect do
            VCR.use_cassette('create_quote_request_with_empty_latestDeliveryTime_payload') do
              described_class.new(payload: payload).execute
            rescue Pedals::Errors::ResponseError => e
              expect(e.status).to eq 422
              expect(e.body).to eq latest_error_response
              raise e
            end
          end.to raise_exception(Pedals::Errors::ResponseError)
        end
      end
    end
  end
end
