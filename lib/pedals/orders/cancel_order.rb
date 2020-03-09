# frozen_string_literal: true

module Pedals
  module Orders
    class CancelOrder < Operation
      def http_method
        :put
      end

      def endpoint(id = nil)
        "#{base_url}/api/v1/orders/#{id}"
      end
    end
  end
end
