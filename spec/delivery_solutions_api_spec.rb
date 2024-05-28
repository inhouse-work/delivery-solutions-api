# frozen_string_literal: true

RSpec.describe DeliverySolutionsAPI do
  describe ".new" do
    it "returns a mock client" do
      client = described_class.new(test: true)
      expect(client).to be_a DeliverySolutionsAPI::Clients::Test
    end

    it "returns a client" do
      client = described_class.new(api_key: "123", tenant_id: "456")
      expect(client).to be_a DeliverySolutionsAPI::Clients::Production
    end
  end
end
