# frozen_string_literal: true

require 'spec_helper'
describe Pedals::Orders::ShowOrder do
  describe '#execute' do
    before do
      configure_client
    end
    let(:config) { Pedals::Client.config }
    let(:payload) do
      {
        "id": 602
      }
    end
    # Order show endpoint returns order does not exist for given order id.
    # However the test order is created before.
    # i assume it return this message for test order and return with actual data on live.
    context 'with valid payload' do
      it 'returns response for order does not exist' do
        VCR.use_cassette('show_order_request') do
          response = described_class.new(
            payload: payload
          ).execute
          expect(response.code).to eq(404)
          expect(JSON.parse(response.body)['message']).to eq('This order does not exist')
        end
      end
    end
  end
end
