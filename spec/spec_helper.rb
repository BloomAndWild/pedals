# frozen_string_literal: true

require 'dotenv'
require 'vcr'

require 'bundler/setup'
require 'pedals'

require_relative 'support/helpers/client_helper'

Dotenv.load('.env.sample')

VCR.configure do |c|
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost                        = true
  c.cassette_library_dir                    = 'spec/support/fixtures/vcr_cassettes'
  c.allow_http_connections_when_no_cassette = true
  c.default_cassette_options                = { match_requests_on: [:uri] }
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
