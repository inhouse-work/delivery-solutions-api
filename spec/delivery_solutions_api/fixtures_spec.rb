# frozen_string_literal: true

RSpec.describe DeliverySolutionsAPI::Fixtures do
  describe ".[]" do
    it "returns the specified fixture as a hash" do
      path = "order/create_order"
      result = described_class[path, 201]

      expect(result).to be_a Hash
      expect(result.fetch(:storeExternalId, nil)).not_to be_nil
    end

    it "returns an empty hash if a fixture hasn't been provided in the gem" do
      path = "non-existent"
      result = described_class[path, 200]

      expect(result).to eq({})
    end
  end

  describe ".directory_exists?" do
    it "returns true if a directory exists with the provided path" do
      path = "rates/get_rates"
      expect(described_class.directory_exists?(path)).to be true
    end

    it "returns false when directory does not exist" do
      path = "non_existent/directory"
      expect(described_class.directory_exists?(path)).to be false
    end
  end

  describe ".fixture_exists?" do
    it "returns true when fixture exists with provided path and status" do
      path = "rates/get_rates"
      status = 200
      expect(described_class.fixture_exists?(path, status)).to be true
    end

    it "returns false when fixture does not exist" do
      path = "rates/get_rates"
      status = 302
      expect(described_class.fixture_exists?(path, status)).to be false
    end
  end
end
