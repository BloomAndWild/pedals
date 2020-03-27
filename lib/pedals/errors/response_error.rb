# frozen_string_literal: true

module Pedals
  module Errors
    class ResponseError < StandardError
      DEFAULT_MESSAGE = "Response body not in json format.".freeze

      def initialize(response)
        @response = response
        super(response_error)
      end

      def status
        @response.status
      end

      def body
        @response.body
      end

      def response_error
        return DEFAULT_MESSAGE if parsed_body.nil?

        parsed_body.dig(:message)
      end

      def parsed_body
        JSON.parse(@response.body).symbolize_keys
      rescue JSON::ParserError
        nil
      end
    end
  end
end
