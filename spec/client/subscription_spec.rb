require 'spec_helper'

describe Subscription do
  before do
    client
  end

  context 'new' do

    subject { User.subscriptions.first }

    it 'returns a subscription for current user' do
      expect(subject).to_not be_nil
      expect(subject).to be_a Subscription
    end

    it 'parses info on user correctly' do
      # Test variables from this specific API call.
      # Might break if vcr recording is deleted. If so, use new values
      expect(subject.id).to eq "s29729296"
      expect(subject.description).to eq "Monthly Subscription"
      expect(subject.expiration_time).to eq DateTime.parse("2016-12-28T09:36:49-05:00")
      expect(subject.price_per_download).to be nil
      expect(subject.license).to eq "standard"
      expect(subject.allotment).to be nil
      expect(subject.formats).to be_a Array
      expect(subject.formats.first).to be_a SubscriptionLicenseFormat
      expect(subject.metadata).to eq nil
    end
  end

  context 'allows_image_size_download?' do

    subject { User.subscriptions.active.first }

    it "correctly finds if image size is possible by this subscription" do
      expect(subject.allows_image_size_download?("small")).to be true
      expect(subject.allows_image_size_download?("made_up_size")).to be false
    end

  end

  context 'expired?' do

    subject { Subscription.new("id" => "s1", "expiration_time" => "2016-12-28T09:36:49-05:00") }

    it "correctly calculates not expired plan" do
      allow(DateTime).to receive(:now).and_return(DateTime.parse("2015-12-28T09:36:49-05:00"))

      expect(subject.expired?).to be false
    end

    it "correctly calculates not expired plan" do
      allow(DateTime).to receive(:now).and_return(DateTime.parse("2017-12-28T09:36:49-05:00"))

      expect(subject.expired?).to be true
    end
  end

end
