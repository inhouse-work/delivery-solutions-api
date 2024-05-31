# frozen_string_literal: true

RSpec.describe DeliverySolutionsAPI::Clients::Production do
  let(:params) do
    {
      api_key: "123",
      tenant_id: "456",
      base_url: "https://example.com"
    }
  end

  describe ".build" do
    it "raises an error if the API key is not provided" do
      expect { described_class.build(**params.slice(:tenant_id, :base_url)) }
        .to raise_error(DeliverySolutionsAPI::Clients::Production::MissingApiKey)
    end

    it "raises an error if the tenant ID is not provided" do
      expect { described_class.build(**params.slice(:api_key, :base_url)) }
        .to raise_error(DeliverySolutionsAPI::Clients::Production::MissingTenantId)
    end

    it "does not raise an error if the API key is provided" do
      expect { described_class.build(**params) }
        .not_to raise_error
    end

    it "reads default values from the environment" do
      stub_const(
        "ENV",
        {
          "DELIVERY_SOLUTIONS_API_KEY" => "123",
          "DELIVERY_SOLUTIONS_TENANT_ID" => "456"
        }
      )

      expect { described_class.build }
        .not_to raise_error
    end
  end

  describe "#get_rates" do
    it "returns rates" do
      response = double("response", read_body: { "rates" => [] }.to_json)
      http = double("client", post: response, address: "https://example.com")
      client = described_class.new(http:, api_key: "123", tenant_id: "456")
      result = client.get_rates

      expect(result).to be_success
    end
  end

  describe "#create_order" do
    it "returns rates" do
      response = double("response", read_body: {}.to_json)
      http = double("client", post: response, address: "https://example.com")
      client = described_class.new(http:, api_key: "123", tenant_id: "456")
      result = client.create_order(something: "something")

      expect(result).to be_success
    end
  end
end
