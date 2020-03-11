# frozen_string_literal: true

module Pedals
  module Orders
    class ShowOrder < Operation
      def http_method
        :get
      end

      def endpoint
        "#{base_url}/api/v1/orders/#{resource_id}"
      end
    end
  end
end
