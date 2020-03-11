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
      it 'raises an exception' do
        VCR.use_cassette('already_cancelled_order_request') do
          expect do
            described_class.new(payload: payload).execute
          end.to raise_exception(Pedals::Errors::ResponseError,
                                 'This order is already cancelled')
        end
      end
    end
  end
end
