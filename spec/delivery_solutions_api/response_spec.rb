# frozen_string_literal: true

RSpec.describe DeliverySolutionsAPI::Response do
  describe "#error?" do
    it "returns true when status code is a failure" do
      payload = DeliverySolutionsAPI::Payload.new({})
      statuses = [500, 400, 404, 409]

      expect(
        described_class.new(status: statuses.sample, payload:).error?
      ).to be true
    end

    it "returns false when status code is not a failure" do
      # DS will send successful responses with errors arrays indicating the
      # failed parts of the request, so we still consider it a success
      payload = DeliverySolutionsAPI::Payload.new(
        {
          errors: [
            {
              message: "Instacart does not provides estimates",
              type: "DSP_DOES_NOT_OFFER_ESTIMATES",
              code: 0,
              provider: "Instacart"
            }
          ]
        }
      )
      statuses = [200, 201]

      expect(
        described_class.new(status: statuses.sample, payload:).error?
      ).to be false
    end
  end

  describe "#success?" do
    it "returns true when request was successful" do
      payload = DeliverySolutionsAPI::Payload.new({ errors: [] })

      expect(described_class.new(status: 201, payload:).success?).to be true
    end
  end
end
