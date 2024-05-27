# frozen_string_literal: true

RSpec.describe DeliverySolutionsAPI::Response do
  describe ".error_response?" do
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

  describe ".success?" do
    it "returns true when request was successful" do
      payload = DeliverySolutionsAPI::Payload.new({ errors: [] })

      expect(described_class.new(payload).success?).to be true
    end
  end
end
