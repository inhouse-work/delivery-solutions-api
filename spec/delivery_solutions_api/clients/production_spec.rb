# frozen_string_literal: true

Session = Data.define(:api_key, :tenant_id)

RSpec.describe DeliverySolutionsAPI::Clients::Production do
  let(:params) do
    {
      base_url: "https://example.com"
    }
  end
  let(:session) { Session.new(api_key: "123", tenant_id: "456") }

  describe "#get_rates" do
    it "returns rates" do
      response = double("response", read: { "rates" => [] }.to_json)
      http = double("client", post: response)
      client = described_class.new(http:, url: "https://example.com")
      result = client.get_rates(session:)

      expect(result).to be_success
    end
  end

  describe "#create_order" do
    it "returns rates" do
      response = double("response", read: {}.to_json)
      http = double("client", post: response)
      client = described_class.new(http:, url: "https://example.com")
      result = client.create_order(
        session:,
        something: "something"
      )

      expect(result).to be_success
    end
  end

  describe "#list_locations" do
    it "returns success" do
      response = double("response", read: [])
      http = double("client", get: response)
      client = described_class.new(http:, url: "https://example.com")
      result = client.list_locations(session:)

      expect(result).to be_success
    end

    it "handles the array we get back from DS" do
      read = File.read("fixtures/pickup_location/list_locations/200-result.json")
      response = double("response", read:)
      http = double("client", get: response)
      client = described_class.new(http:, url: "https://example.com")
      result = client.list_locations(session:)

      expect(result).to be_success
    end
  end

  describe "#create_location" do
    it "returns success" do
      response = double("response", read: {}.to_json)
      http = double("client", post: response)
      client = described_class.new(http:, url: "https://example.com")
      result = client.create_location(
        session:,
        params: {}
      )

      expect(result).to be_success
    end
  end
end
