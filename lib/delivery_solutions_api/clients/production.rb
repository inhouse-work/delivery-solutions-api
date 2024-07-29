# frozen_string_literal: true

require "net/http"
require "uri"

module DeliverySolutionsAPI
  module Clients
    class Production < Client
      PRODUCTION_URL = "https://production.api.deliverysolutions.co"
      SANDBOX_URL = "https://sandbox.api.deliverysolutions.co"

      def self.build(sandbox: false)
        url = if sandbox
          URI.parse(SANDBOX_URL)
        else
          URI.parse(PRODUCTION_URL)
        end
        http = ::Net::HTTP.new(url.host, url.port).tap do |http|
          http.use_ssl = true
        end

        new(http:)
      end

      def initialize(http:)
        @http = http
        @url = URI.parse(@http.address)
      end

      def get_rates(session:, **params)
        path = "/api/v2/rates"
        post(session:, path:, params:)
      end

      def list_locations(session:)
        path = "/api/v2/store"
        get(session:, path:)
      end

      def create_order(session:, **params)
        path = "/api/v2/order/placeorderasync"
        post(session:, path:, params:)
      end

      def cancel_order(session:, order_external_id:)
        path = "/api/v2/order/orderExternalId/#{order_external_id}"
        delete(session:, path:)
      end

      def create_location(session:, params:)
        path = "/api/v2/store"
        post(session:, path:, params:)
      end

      private

      def get(session:, path:, params: {})
        @url.dup.then do |url|
          url.path = path
          url.query = ::URI.encode_www_form(params)
          response = @http.get(url.path, headers(session))
          Response.parse(response.read_body)
        end
      end

      def post(session:, path:, params:)
        response = @http.post(
          path,
          DeliverySolutionsAPI::JSON.stringify(params),
          headers(session)
        )
        Response.parse(response.read_body)
      end

      def delete(session:, path:)
        response = @http.delete(path, headers(session))
        Response.parse(response.read_body)
      end

      def headers(session)
        {
          "Content-Type" => "application/json",
          "x-api-key" => session.api_key,
          "tenantid" => session.tenant_id
        }
      end
    end
  end
end
