# frozen_string_literal: true

class Operation
  def initialize(**options)
    @options = options
  end

  def execute
    conn = Faraday.new
    conn.basic_auth username, password
    response = conn.run_request(http_method, endpoint, payload.to_json, headers)
    unless response.success?
      raise Pedals::Errors::ResponseError.new(response)
    end
    status = response.status
    body = parsed_response(response.body)
    OpenStruct.new(body: body, code: status)
  end

  def headers
    {
      content_type: 'application/json'
    }.merge(options.fetch(:headers, {}))
  end

  def payload
    options.fetch(:payload, {})
  end

  def resource_id
    payload.delete(:id)
  end

  def config
    Pedals::Client.config
  end

  private

  def parsed_response(response)
    JSON.parse(response, symbolize_names: true)
  end

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
