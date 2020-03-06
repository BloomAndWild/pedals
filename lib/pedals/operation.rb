# frozen_string_literal: true

class Operation
  def initialize(**options)
    @options = options
  end

  def execute
    RestClient::Request.execute(
      method: http_method, url: endpoint,
      payload: payload, headers: headers
    )
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end

  def headers
    {
      content_type: 'application/json',
      authorization: "#{username} #{payload}"
    }.merge(options.fetch(:headers, {}))
  end

  def payload
    options.fetch(:payload, {}).to_json
  end

  def config
    Pedals::Client.config
  end

  def parsed_response(response)
    JSON.parse(response)
  end

  private

  attr_reader :options

  def base_url
    config.base_url
  end

  def username
    config.username
  end

  def password
    config.password
  end
end
