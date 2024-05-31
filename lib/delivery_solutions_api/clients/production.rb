# frozen_string_literal: true

require "net/http"
require "uri"

module DeliverySolutionsAPI
  module Clients
    class Production < Client
      PRODUCTION_URL = "https://production.api.deliverysolutions.co"
      SANDBOX_URL = "https://sandbox.api.deliverysolutions.co"

      MissingApiKey = Class.new(ArgumentError)
      MissingTenantId = Class.new(ArgumentError)

      def self.build(
        api_key: ENV.fetch("DELIVERY_SOLUTIONS_API_KEY", nil),
        tenant_id: ENV.fetch("DELIVERY_SOLUTIONS_TENANT_ID", nil),
        base_url: PRODUCTION_URL
      )
        url = URI.parse(base_url)
        http = ::Net::HTTP.new(url.host, url.port).tap do |http|
          http.use_ssl = true
        end

        new(api_key:, tenant_id:, http:)
      end

      def initialize(http:, api_key:, tenant_id:)
        raise MissingApiKey, "Missing API key" if api_key.nil?
        raise MissingTenantId, "Missing tenant ID" if tenant_id.nil?

        @api_key = api_key
        @tenant_id = tenant_id
        @http = http
        @url = URI.parse(@http.address)
      end

      def get_rates(**params)
        path = "/api/v2/rates"
        post(path:, params:)
      end

      def create_order(**params)
        path = "/api/v2/order/placeorderasync"
        post(path:, params:)
      end

      private

      def get(path:, params: {})
        @url.dup.tap do |url|
          url.path = path
          url.query = ::URI.encode_www_form(params)
          response = @http.get(url.path, headers)
          Response.parse(response.read_body)
        end
      end

      def post(path:, params:)
        response = @http.post(
          path,
          DeliverySolutionsAPI::JSON.stringify(params),
          headers
        )
        Response.parse(response.read_body)
      end

      def headers
        {
          "Content-Type" => "application/json",
          "x-api-key" => @api_key,
          "tenantid" => @tenant_id
        }
      end
    end
  end
end
