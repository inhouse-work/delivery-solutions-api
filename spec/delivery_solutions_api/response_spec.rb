# frozen_string_literal: true

RSpec.describe DeliverySolutionsAPI::Response do
  describe "#error?" do
    it "returns false when errors aren't present" do
      payload = DeliverySolutionsAPI::Payload.new({ errors: [] })

      expect(described_class.new(payload).error?).to be false
    end

    it "returns true when errors are present" do
      payload = DeliverySolutionsAPI::Payload.new({ errors: [{ type: "test" }] })

      expect(described_class.new(payload).error?).to be true
    end

    it "returns false when errors aren't present (from user stubs)" do
      payload = DeliverySolutionsAPI::Payload.new({ stubbed_data: "test" })

      expect(described_class.new(payload).error?).to be false
    end

    it "handles a 500 server error payload" do
      payload = DeliverySolutionsAPI::Payload.new(
        {
          statusCode: 500,
          message: "Internal server error"
        }
      )

      expect(described_class.new(payload).error?).to be true
    end
  end

  describe "#success?" do
    it "returns true when request was successful" do
      payload = DeliverySolutionsAPI::Payload.new({ errors: [] })

      expect(described_class.new(payload).success?).to be true
    end
  end

  describe ".parse" do
    it "overrides to_s to inspect for showing internal attributes" do
      response = File
        .read("fixtures/order/create_order/400-result.json")
        .then { |json| JSON.parse(json, symbolize_names: true) }

      payload = DeliverySolutionsAPI::Payload.new(response)
      response = described_class.parse(payload)

      expect(response.success?).to be false
      expect(response).to be_a described_class
      expect(response.to_s).to eq response.inspect
    end
  end
end
