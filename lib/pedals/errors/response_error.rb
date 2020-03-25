# frozen_string_literal: true

module Pedals
  module Errors
    class ResponseError < StandardError
      def initialize(response)
        @response = response
      end

      def status
        @response.status
      end

      def body
        @response.body
      end
    end
  end
end
