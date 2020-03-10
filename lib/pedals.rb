# frozen_string_literal: true

require 'pedals/version'
require 'faraday'
require 'json'
require 'ostruct'
require 'pedals/operation'
require 'pedals/client'
require 'pedals/config'
require 'pedals/quote/create_quote'
require 'pedals/errors/response_error'
require 'pedals/orders/create_order'
require 'pedals/orders/show_order'
require 'pedals/orders/cancel_order'
require 'active_support/all'

module Pedals
  class Error < StandardError; end
  # Your code goes here...
end
