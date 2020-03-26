# frozen_string_literal: true

require 'spec_helper'
describe Pedals::Orders::CancelOrder do
  describe '#execute' do
    before do
      configure_client
    end
    let(:config) { Pedals::Client.config }
    let(:payload) do
      {
        id: 604
      }
    end

    context 'with valid payload' do
      it 'returns valid response' do
        VCR.use_cassette('valid_cancel_order_request') do
          response = described_class.new(
            payload: payload
          ).execute

          expect(response.code).to eq(200)
          expect(response.body[:status]).to eq('cancelled')
          expect(response.body[:refundAmount]).to eq(1006)
          expect(response.body[:id]).to eq(604)
        end
      end
    end

    context 'when order is already cancelled' do
      let(:error_response_json) do
        { "field" => nil, "message" => "This order is already cancelled" }
      end

      it 'raises an exception' do
        expect do
          VCR.use_cassette('already_cancelled_order_request') do
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
