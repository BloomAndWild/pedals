# frozen_string_literal: true

module Pedals
  module Orders
    class ShowOrder < Operation
      def http_method
        :get
      end

      def endpoint(id = nil)
        "#{base_url}/api/v1/orders/#{id}"
      end
    end
  end
end
