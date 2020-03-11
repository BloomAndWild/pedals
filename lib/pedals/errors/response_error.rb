# frozen_string_literal: true

module Pedals
  module Errors
    class ResponseError < StandardError
      def initialize(message)
        super(message)
      end
    end
  end
end
