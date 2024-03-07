# frozen_string_literal: true

RSpec.describe DeliverySolutions::Errors do
  describe ".localized" do
    it "returns an InvalidData error when type matches" do
      expect(
        described_class.localized("INVALID_DATA")
      ).to be DeliverySolutions::Errors::InvalidData
    end

    it "returns a ValidationError when type matches" do
      expect(
        described_class.localized("NO_DSP_MATCHED")
      ).to be DeliverySolutions::Errors::NoDspMatched
    end
  end
end
