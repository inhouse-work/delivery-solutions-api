# frozen_string_literal: true

RSpec.describe DeliverySolutions::Fixtures do
  describe ".[]" do
    it "returns the specified fixture as a hash" do
      key = "order/create_order/201-result"
      result = described_class[key]

      expect(result).to be_a Hash
      expect(result.fetch(:storeExternalId, nil)).not_to be_nil
    end

    it "returns an empty hash if a fixture hasn't been provided in the gem" do
      key = "non-existent"
      result = described_class[key]

      expect(result).to eq({})
    end
  end

  describe ".key?" do
    it "returns true if a fixture exists with the provided name" do
      key = "order/create_order/201-result"
      expect(described_class.key?(key)).to be true
    end
  end
end
