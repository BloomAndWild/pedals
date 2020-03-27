# frozen_string_literal: true

require 'spec_helper'
describe Pedals::Orders::ShowOrder do
  describe '#execute' do
    before do
      configure_client
    end
    let(:config) { Pedals::Client.config }

    context 'list all orders' do
      let(:payload) { { field: nil } }

      it 'returns valid response' do
        VCR.use_cassette('list_orders_request') do
          response = described_class.new(payload: payload).execute
          expect(response.code).to eq(200)
          expect(response.body[:orders]).to_not be_empty
        end
      end
    end

    context 'with valid payload' do
      let(:payload) { { id: 673 } }

      it 'returns valid response' do
        VCR.use_cassette('show_order_request') do
          response = described_class.new(payload: payload).execute
          expect(response.code).to eq(200)
          expect(response.body[:id]).to eq(673)
        end
      end
    end

    context 'with invalid payload' do
      let(:payload) { { id: 6040 } }

      let(:error_response_json) do
        { "field" => nil, "message" => "This order does not exist" }
      end

      it 'raises an exception if the order does not exist' do
        expect do
          VCR.use_cassette('show_missing_order_request') do
            described_class.new(payload: payload).execute
          rescue Pedals::Errors::ResponseError => e
            expect(e.status).to eq 404
            expect(JSON.parse(e.body)).to eq error_response_json
            raise e
          end
        end.to raise_exception(Pedals::Errors::ResponseError)
      end
    end
  end
end
