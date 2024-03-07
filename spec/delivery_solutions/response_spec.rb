# frozen_string_literal: true

RSpec.describe DeliverySolutions::Response do
  describe ".error_response?" do
    it "returns false when errors aren't present" do
      payload = DeliverySolutions::Payload.new({ errors: [] })

      expect(described_class.new(payload).error?).to be false
    end

    it "returns true when errors are present" do
      payload = DeliverySolutions::Payload.new({ errors: [{ type: "test" }] })

      expect(described_class.new(payload).error?).to be true
    end

    it "returns false when errors aren't present (from user stubs)" do
      payload = DeliverySolutions::Payload.new({ stubbed_data: "test" })

      expect(described_class.new(payload).error?).to be false
    end
  end

  describe ".success?" do
    it "returns true when request was successful" do
      payload = DeliverySolutions::Payload.new({ errors: [] })

      expect(described_class.new(payload).success?).to be true
    end
  end
end
