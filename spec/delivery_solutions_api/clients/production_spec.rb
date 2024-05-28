# frozen_string_literal: true

RSpec.describe DeliverySolutionsAPI::Clients::Production do
  let(:params) do
    {
      api_key: "123",
      tenant_id: "456",
      base_url: "https://example.com"
    }
  end

  describe "#initialize" do
    it "raises an error if the API key is not provided" do
      expect { described_class.new(**params.slice(:tenant_id, :base_url)) }
        .to raise_error(DeliverySolutionsAPI::Clients::Production::MissingApiKey)
    end

    it "raises an error if the tenant ID is not provided" do
      expect { described_class.new(**params.slice(:api_key, :base_url)) }
        .to raise_error(DeliverySolutionsAPI::Clients::Production::MissingTenantId)
    end

    it "does not raise an error if the API key is provided" do
      expect { described_class.new(**params) }
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

      expect { described_class.new }
        .not_to raise_error
    end
  end
end
