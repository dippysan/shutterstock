require 'spec_helper'

describe SubscriptionLicenseFormat do
  before do
    client
  end

  context 'new' do

    subject { User.subscriptions.first.formats.first }

    it 'returns a subscription license format for current user' do
      expect(subject).to_not be_nil
      expect(subject).to be_a SubscriptionLicenseFormat
    end

    it 'parses info correctly' do
      # Test variables from this specific API call.
      # Might break if vcr recording is deleted. If so, use new values
      expect(subject.description).to eq "Huge"
      expect(subject.min_resolution).to eq 4000000
      expect(subject.media_type).to eq "image"
      expect(subject.format).to eq "jpg"
      expect(subject.size).to eq "huge"
    end

  end

end
