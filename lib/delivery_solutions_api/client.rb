# frozen_string_literal: true

require "net/http"
require "uri"

module DeliverySolutionsAPI
  class Client
    PRODUCTION_URL = "https://production.api.deliverysolutions.co/"
    SANDBOX_URL = "https://sandbox.api.deliverysolutions.co/"

    MissingClientStub = Class.new(StandardError)

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

      new(url: URI(url), environment:, http:)
    end

    def initialize(http:, url:, environment:)
      @http = http
      @url = URI(url)
      @environment = environment
    end

    def get_rates(session:, **params)
      post(path: "/api/v2/rates", session:, params:)
    end

    def list_locations(session:)
      get(path: "/api/v2/store", session:)
    end

    def create_order(session:, **params)
      post(path: "/api/v2/order/placeorderasync", session:, params:)
    end

    def cancel_order(session:, order_external_id:)
      delete(
        path: "/api/v2/order/orderExternalId/#{order_external_id}",
        session:
      )
    end

    def create_location(session:, params:)
      post(path: "/api/v2/store", session:, params:)
    end

    private

    def get(session:, path:, params: {})
      raise_stubbing_error if test?

      url_for(path).then do |url|
        url.query = ::URI.encode_www_form(params)
        response = @http.get(url, headers: headers(session))
        build_response(response, params)
      end
    end

    def url_for(path)
      @url.dup.tap { |url| url.path = path }
    end

    def post(session:, path:, params:)
      raise_stubbing_error(path) if test?

      response = @http.post(
        url_for(path),
        json: params,
        headers: headers(session)
      )

      build_response(response, params)
    end

    def delete(session:, path:)
      raise_stubbing_error if test?

      response = @http.delete(url_for(path), headers: headers(session))
      build_response(response)
    end

    def raise_stubbing_error(path)
      raise(
        MissingClientStub,
        <<~MSG
          You tried to fetch #{path} using the DeliverySolutionsAPI testing client.
          You should create an instance double and stub the message using DeliverySolutionsAPI.stubbed_response instead:

          client = instance_double(
            DeliverySolutionsAPI::Client,
            get_rates: DeliverySolutionsAPI.stubbed_response(
              "rates/get_rates",
              status_code: 200
            )
          )

          Or if you need to override the fixture:

          client = instance_double(
            DeliverySolutionsAPI::Client,
            get_rates: DeliverySolutionsAPI.stubbed_response(
              fixture: DeliverySolutionsAPI.fixture(
                "rates/get_rates",
                status_code: 200
              )
            )
          )
        MSG
      )
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

    def build_response(response, params = nil)
      Response.parse(payload: response.read, status: response.status, params:)
    end
  end
end
