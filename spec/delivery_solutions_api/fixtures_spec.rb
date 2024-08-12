# frozen_string_literal: true

RSpec.describe DeliverySolutionsAPI::Fixtures do
  describe ".[]" do
    it "returns the specified fixture as a hash" do
      path = "order/create_order"
      result = described_class[path, 201]

      expect(result).to be_a Hash
      expect(result.fetch(:storeExternalId, nil)).not_to be_nil
    end

    it "raises an argument error if the fixture does not exist" do
      path = "non-existent"

      expect { described_class[path, 200] }.to raise_error(ArgumentError)
    end
  end
end
