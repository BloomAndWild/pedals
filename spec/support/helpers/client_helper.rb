# frozen_string_literal: true

require 'logger'

def configure_client
  Pedals::Client.configure do |config|
    logger = Logger.new(STDERR)
    logger.level = :debug

    config.base_url = ENV.fetch('SANDBOX_BASE_URL')
    config.username = ENV.fetch('SANDBOX_USERNAME')
    config.password = ENV.fetch('SANDBOX_PASSWORD')
    config.logger = logger
  end
end
