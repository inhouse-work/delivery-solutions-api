# frozen_string_literal: true

RSpec.describe DeliverySolutionsAPI::Clients::Test do
  describe "#get_rates" do
    it "returns the success fixture by status" do
      client = described_class.build(raise_api_errors: false)
      result = client.get_rates(status: 200)

      expect(result[:rates].size).to eq 3
    end

    it "returns the failure fixture by status" do
      client = described_class.build(raise_api_errors: false)
      result = client.get_rates(status: 400)

      expect(result.keys.first).to eq :errors
      expect(result[:type]).to eq "INVALID_DATA"
    end

    context "stubbing out attributes" do
      it "stubs a flat attribute" do
        client = described_class.build(raise_api_errors: false)
        result = client.get_rates(status: 200, rateId: "123")

        expect(result[:rateId]).to eq "123"
      end
    end
  end

  describe "#list_locations" do
    it "returns the success fixture by status" do
      client = described_class.build(raise_api_errors: false)
      result = client.list_locations(status: 200)

      expect(result.size).to eq 1
      expect(result.first[:name]).to eq "NYCStore"
    end

    it "returns the failure fixture by status" do
      client = described_class.build(raise_api_errors: false)
      result = client.list_locations(status: 400)

      expect(result.empty?).to be true
    end

    # TODO: Stubbing out attributes on arrays
    # context "stubbing out attributes" do
    # end
  end

  describe "#create_order" do
    it "returns success fixture by status" do
      client = described_class.build(raise_api_errors: false)
      result = client.create_order(status: 201)

      expect(result[:orderExternalId]).to eq "7709-001"
    end

    it "returns failure fixture by status" do
      client = described_class.build(raise_api_errors: false)
      result = client.create_order(status: 400)

      expect(result.keys.first).to eq :errors
      expect(result[:type]).to eq "INVALID_DATA"
    end

    context "stubbing out attributes" do
      it "stubs flat attributes" do
        client = described_class.build(raise_api_errors: false)
        result = client.create_order(
          status: 201,
          orderExternalId: "my-custom-id",
          itemList: []
        )

        expect(result[:orderExternalId]).to eq "my-custom-id"
        expect(result[:itemList]).to be_empty
      end
    end
  end

  describe "#cancel_order" do
    it "returns success fixture by status" do
      client = described_class.build(raise_api_errors: false)
      result = client.cancel_order(status: 200)

      expect(result[:_id]).to eq "62a9e3ce87f3c9df15080f00"
    end

    it "returns failure fixture by status" do
      client = described_class.build(raise_api_errors: false)
      result = client.cancel_order(status: 400)

      expect(result[:type]).to eq "ORDER_CANCELLATION_FAILED"
      expect(result[:message]).to eq "DSP failed to cancel order"
    end

    context "stubbing out attributes" do
      it "stubs flat attributes" do
        client = described_class.build(raise_api_errors: false)
        result = client.cancel_order(
          status: 200,
          _id: "my-custom-id"
        )

        expect(result[:_id]).to eq "my-custom-id"
      end
    end
  end

  describe "#create_location" do
    it "returns success fixture by status" do
      client = described_class.build(raise_api_errors: false)
      result = client.create_location(status: 201)

      expect(result[:name]).to eq "Excellent Pickup Location"
    end

    it "returns failure fixture by status" do
      client = described_class.build(raise_api_errors: false)
      result = client.create_location(status: 400)

      expect(result[:type]).to eq "NOT_FOUND"
      expect(result[:message]).to eq "Walmart GoLocal DSP is not configure in system"
    end
  end
end
