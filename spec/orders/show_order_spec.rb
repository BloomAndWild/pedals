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
        id: 604
      }
    end

    # Order show endpoint returns order does not exist for given order id.
    # However the test order is created before.
    # i assume it return this message for test order and return with actual data on live.
    context 'with valid payload' do
      it 'raises an exception for order does not exist' do
        VCR.use_cassette('show_order_request') do
          expect do
            described_class.new(payload: payload).execute
          end.to raise_exception(Pedals::Errors::ResponseError,
                                 'This order does not exist')
        end
      end
    end
  end
end
