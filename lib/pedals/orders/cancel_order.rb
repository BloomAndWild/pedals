# frozen_string_literal: true

module Pedals
  module Orders
    class CancelOrder < Operation
      CANCEL_STATE = 'cancelled'
      def http_method
        :put
      end

      def endpoint
        "#{base_url}/api/v1/orders/#{resource_id}"
      end

      def payload
        payload = options.fetch(:payload, {})
        payload.merge(status: CANCEL_STATE).to_json unless payload.empty?
      end
    end
  end
end
