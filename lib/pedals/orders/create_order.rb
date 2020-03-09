# frozen_string_literal: true

module Pedals
  module Orders
    class CreateOrder < Operation
      def http_method
        :post
      end

      def endpoint(_id = nil)
        "#{base_url}/api/v1/orders"
      end
    end
  end
end
