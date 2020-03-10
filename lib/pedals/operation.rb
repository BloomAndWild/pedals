# frozen_string_literal: true

class Operation
  def initialize(**options)
    @options = options
  end

  def execute
    conn = Faraday.new
    conn.basic_auth username, password
    response = conn.run_request(http_method, endpoint, payload, headers)
    unless response.success?
      raise Pedals::Errors::ResponseError,
            parsed_response(response.body).dig('message')
    end
    OpenStruct.new(body: response.body, code: response.status)
  end

  def headers
    {
      content_type: 'application/json'
    }.merge(options.fetch(:headers, {}))
  end

  def payload
    options.fetch(:payload, {}).to_json
  end

  def resource_id
    JSON.parse(payload).delete('id')
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
