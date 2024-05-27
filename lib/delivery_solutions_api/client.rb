# frozen_string_literal: true

require "net/http"
require "uri"

module DeliverySolutionsAPI
  class Client
    PRODUCTION_URL = "https://production.api.deliverysolutions.co".freeze
    SANDBOX_URL = "https://sandbox.api.deliverysolutions.co".freeze

    MissingApiKey = Class.new(ArgumentError)
    MissingTenantId = Class.new(ArgumentError)

    def initialize(
      api_key: ENV.fetch("DELIVERY_SOLUTIONS_API_KEY", nil),
      tenant_id: ENV.fetch("DELIVERY_SOLUTIONS_TENANT_ID", nil),
      base_url: PRODUCTION_URL
    )
      raise MissingApiKey, "Missing API key" if api_key.nil?
      raise MissingTenantId, "Missing tenant ID" if tenant_id.nil?

      @api_key = api_key
      @tenant_id = tenant_id
      @base_url = base_url
    end

    def get_rates(params)
      path = "/api/v2/rates"
      post(path, params)
    end

    def create_order(params)
      path = "/api/v2/order/placeorderasync"
      post(path, params)
    end

    private

    def get(path)
      uri = ::URI.parse(@base_url + path)
      uri.query = ::URI.encode_www_form(params)
      request = ::Net::HTTP::Get.new(uri, headers)
      response = http.request(request)
      Response.parse(response.read_body)
    end

    def post(path, params)
      uri = ::URI.parse(@base_url + path)
      request = ::Net::HTTP::Post.new(uri, headers)
      response = http(uri).request(request, JSON.stringify(params))
      Response.parse(response.read_body)
    end

    def headers
      # rubocop:disable Style/StringHashKeys
      {
        "Content-Type" => "application/json",
        "x-api-key" => @api_key,
        "tenantid" => @tenant_id
      }
      # rubocop:enable Style/StringHashKeys
    end

    def http(uri)
      ::Net::HTTP.new(uri.host, uri.port).tap do |http|
        http.use_ssl = true
      end
    end
  end
end
