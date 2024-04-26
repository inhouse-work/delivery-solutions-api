# frozen_string_literal: true

RSpec.describe DeliverySolutions do
  describe ".new" do
    it "returns a mock client" do
      expect(described_class.new(test: true)).to be_a DeliverySolutions::MockClient
    end

    it "returns a client" do
      expect(
        described_class.new(api_key: 123, tenant_id: 456)
      ).to be_a DeliverySolutions::Client
    end
  end
end
