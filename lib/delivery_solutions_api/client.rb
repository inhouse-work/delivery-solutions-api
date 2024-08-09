# frozen_string_literal: true

require "net/http"
require "uri"

module DeliverySolutionsAPI
  class Client
    PRODUCTION_URL = "https://production.api.deliverysolutions.co/"
    SANDBOX_URL = "https://sandbox.api.deliverysolutions.co/"

    def production?
      @environment == :production
    end

    def sandbox?
      @environment == :sandbox
    end

    def test?
      @environment == :test
    end

    def self.build(sandbox: false, test: false)
      url = sandbox ? SANDBOX_URL : PRODUCTION_URL
      environment = :test if test
      environment = (sandbox ? :sandbox : :production) unless test
      http = HTTPX

      new(
        http:,
        url: URI(url),
        environment:
      )
    end

    def initialize(http:, url:, environment:)
      @http = http
      @url = URI(url)
      @environment = environment
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
      raise_stubbing_error if test?

      url_for(path).then do |url|
        url.query = ::URI.encode_www_form(params)
        response = @http.get(url, headers: headers(session))
        build_response(response)
      end
    end

    def url_for(path)
      @url.dup.tap { |url| url.path = path }
    end

    def post(session:, path:, params:)
      raise_stubbing_error if test?

      response = @http.post(
        url_for(path),
        json: params,
        headers: headers(session)
      )

      build_response(response)
    end

    def delete(session:, path:)
      raise_stubbing_error if test?

      response = @http.delete(url_for(path), headers: headers(session))
      build_response(response)
    end

    def raise_stubbing_error
      raise ArgumentError, "This method is not available in test mode"
    end

    def headers(session)
      {
        "accept" => "application/json",
        "content-type" => "application/json",
        "x-compression" => "true",
        "x-api-key" => session.api_key,
        "tenantId" => session.tenant_id
      }
    end

    def build_response(response)
      Response.parse(payload: response.read, status: response.status)
    end
  end
end
