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
        "id": 592,
        "status": 'cancelled'
      }
    end
    context 'with valid payload' do
      it 'returns valid response' do
        VCR.use_cassette('valid_cancel_order_request') do
          response = described_class.new(
            payload: payload
          ).execute
          expect(response.code).to eq(200)
          expect(JSON.parse(response.body)['status']).to eq('cancelled')
          expect(JSON.parse(response.body)['refundAmount']).to eq(1006)
          expect(JSON.parse(response.body)['id']).to eq(592)
        end
      end
    end

    context 'when order is already cancelled' do
      it 'return info message' do
        VCR.use_cassette('already_cancelled_order_request') do
          response = described_class.new(
            payload: payload
          ).execute
          expect(response.code).to eq(422)
          expect(JSON.parse(response.body)['message']).to eq('This order is already cancelled')
        end
      end
    end
    context 'with invalid payload' do
      context 'When status is empty' do
        it 'returns error message' do
          payload[:status] = ''
          VCR.use_cassette('create_order_request_with_empty_status_payload') do
            response = described_class.new(
              payload: payload
            ).execute
            expect(response.code).to eq(422)
            expect(JSON.parse(response)['field']).to eq('status')
            expect(JSON.parse(response)['message']).to eq('Property [status] of class [class pedals.OrderCancel] cannot be null')
          end
        end
      end

      context 'When invalid status is provided for cancel order' do
        it 'returns error message' do
          payload[:status] = 'active'
          VCR.use_cassette('cancel_order_request_with_invalid_status_payload') do
            response = described_class.new(
              payload: payload
            ).execute
            expect(response.code).to eq(422)
            expect(JSON.parse(response)['field']).to eq('status')
            expect(JSON.parse(response)['message']).to eq('Property [status] of class [class pedals.OrderCancel] with value [active] is not contained within the list [[cancelled]]')
          end
        end
      end
    end
  end
end
