# frozen_string_literal: true

RSpec.describe DeliverySolutionsAPI::Errors do
  describe ".localized" do
    it "returns an InvalidData error when type matches" do
      expect(
        described_class.localized("INVALID_DATA")
      ).to be DeliverySolutionsAPI::Errors::InvalidData
    end

    it "returns a ValidationError when type matches" do
      expect(
        described_class.localized("NO_DSP_MATCHED")
      ).to be DeliverySolutionsAPI::Errors::NoDspMatched
    end
  end
end
