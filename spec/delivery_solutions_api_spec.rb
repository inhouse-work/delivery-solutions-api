# frozen_string_literal: true

RSpec.describe DeliverySolutionsAPI do
  describe "#stubbed_response" do
    it "returns a response" do
      result = described_class.stubbed_response("rates/get_rates", status_code: 200)

      expect(result).to be_a DeliverySolutionsAPI::Response
      expect(result.success?).to be true
    end

    it "returns a failure response" do
      result = described_class.stubbed_response(
        "rates/get_rates",
        status_code: 400
      )

      expect(result.success?).to be false
    end
  end

  describe "#test_client" do
    it "returns the base client" do
      client = described_class.test_client
      expect(client).to be_a DeliverySolutionsAPI::Client
      expect { client.get_rates({}) }
        .to raise_error NotImplementedError
    end
  end

  describe "#sandbox_client" do
    it "returns a sandbox client" do
      client = described_class.sandbox_client

      expect(client).to be_a DeliverySolutionsAPI::LiveClient
      expect(client.production?).to be false
    end
  end

  describe "#production_client" do
    it "retuns a production client" do
      client = described_class.production_client

      expect(client).to be_a DeliverySolutionsAPI::LiveClient
      expect(client.production?).to be true
    end
  end
end
