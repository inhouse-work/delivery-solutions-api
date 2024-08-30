# frozen_string_literal: true

RSpec.describe DeliverySolutionsAPI::Client do
  def http_client(**)
    class_double(HTTPX, **)
  end

  def http_response(body: {})
    instance_double(
      HTTPX::Response,
      read: body.to_json,
      status: 200
    )
  end

  let(:session) do
    DeliverySolutionsAPI.build_session(api_key: "123", tenant_id: "456")
  end

  describe "#get_rates" do
    it "returns rates" do
      response = http_response
      http = http_client(post: response)
      client = build_client(http)
      result = client.get_rates(session:)

      expect(result).to be_success
    end
  end

  describe "#create_order" do
    it "returns rates" do
      response = http_response
      http = http_client(post: response)
      client = build_client(http)
      result = client.create_order(
        session:,
        something: "something"
      )

      expect(result).to be_success
    end
  end

  describe "#list_locations" do
    it "returns success" do
      response = http_response
      http = http_client(get: response)
      client = build_client(http)
      result = client.list_locations(session:)

      expect(result).to be_success
    end

    it "handles the array we get back from DS" do
      body = DeliverySolutionsAPI.fixture(
        "pickup_location/list_locations",
        status_code: 200
      )
      response = http_response(body:)
      http = http_client(get: response)
      client = build_client(http)
      result = client.list_locations(session:)

      expect(result).to be_success
    end
  end

  describe "#create_location" do
    it "returns success" do
      response = http_response(body: {})
      http = http_client(post: response)
      client = build_client(http)
      result = client.create_location(session:, params: {})

      expect(result).to be_success
    end
  end

  describe "#edit_location" do
    it "returns success" do
      response = http_response(body: {})
      http = http_client(patch: response)
      client = build_client(http)
      result = client.edit_location(
        session:,
        store_external_id: "123",
        params: {}
      )

      expect(result).to be_success
    end
  end

  def build_client(http)
    described_class.new(http:, url: "https://example.com", environment: :sandbox)
  end
end
