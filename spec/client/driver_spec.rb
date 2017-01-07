require 'spec_helper'

describe Driver do
  describe "#json_true?" do
    it "returns true for any truthy json value" do
      Driver::TRUTHY_JSON_VALUES.each do |value|
        expect(subject.json_true?(value)).to be true
      end
    end

    it "returns false for null" do
      expect(subject.json_true?(nil)).to be false
    end

    it "return false for non-truthy values" do
      expect(subject.json_true?("FALSE")).to be false
    end
  end

end
