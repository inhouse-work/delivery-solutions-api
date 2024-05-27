# frozen_string_literal: true

RSpec.describe DeliverySolutionsAPI::MergeFixture do
  describe ".call" do
    it "raises an argument error on an unsupported payload" do
      command = -> do
        described_class.call(
          payload: 1,
          method_name: :create_order,
          status: :success
        )
      end

      expect(&command).to raise_error(
        ArgumentError,
        "Unsupported payload type Integer"
      )
    end

    it "merges the hash fixture" do
      payload = { type: "test" }

      merged = described_class.call(
        payload:,
        method_name: :create_order,
        status: :success
      )

      expect(merged.fetch(:type)).to eq "test"
    end

    it "merges the array fixture" do
      payload = [{ provider: "test" }]

      merged = described_class.call(
        payload:,
        method_name: :get_alternate_locations,
        status: :success
      )

      expect(merged.first.fetch(:provider)).to eq "test"
    end

    it "handles an empty array being passed as a stub" do
      payload = []
      merged = described_class.call(
        payload:,
        method_name: :list_locations,
        status: :success
      )

      expect(merged).to eq []
    end
  end
end
