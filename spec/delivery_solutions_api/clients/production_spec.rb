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
      response = double("response", read_body: { "rates" => [] }.to_json)
      http = double("client", post: response, address: "https://example.com")
      client = described_class.new(http:)
      result = client.get_rates(session:)

      expect(result).to be_success
    end
  end

  describe "#create_order" do
    it "returns rates" do
      response = double("response", read_body: {}.to_json)
      http = double("client", post: response, address: "https://example.com")
      client = described_class.new(http:)
      result = client.create_order(
        session:,
        something: "something"
      )

      expect(result).to be_success
    end
  end

  describe "#list_locations" do
    it "returns success" do
      response = double("response", read_body: [])
      http = double("client", get: response, address: "https://example.com")
      client = described_class.new(http:)
      result = client.list_locations(session:)

      expect(result).to be_success
    end

    it "handles the array we get back from DS" do
      read_body = File.read("fixtures/pickup_location/list_locations/200-result.json")
      response = double("response", read_body:)
      http = double("client", get: response, address: "https://example.com")
      client = described_class.new(http:)
      result = client.list_locations(session:)

      expect(result).to be_success
    end
  end
end
