# frozen_string_literal: true

module Pedals
  module Orders
    class CancelOrder < Operation
      def http_method
        :put
      end

      def endpoint
        "#{base_url}/api/v1/orders/#{resource_id}"
      end

      def payload
        payload = options.fetch(:payload, {})
        payload.merge(status: 'cancelled').to_json unless payload.empty?
      end

      def resource_id
        JSON.parse(payload).delete('id')
      end
    end
  end
end
