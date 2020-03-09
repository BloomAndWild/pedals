# frozen_string_literal: true

module Pedals
  module Quote
    class CreateQuote < Operation
      def http_method
        :post
      end

      def endpoint(_id = nil)
        "#{base_url}/api/v1/quotes"
      end
    end
  end
end
