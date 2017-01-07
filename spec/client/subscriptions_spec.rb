require 'spec_helper'

describe Subscriptions do
  before do
    client
  end

  context 'subscriptions' do

    subject { User.subscriptions }

    it 'returns all subscriptions for current user' do
      expect(subject).to_not be_nil
      expect(subject).to be_a Array
      expect(subject.first).to be_a Subscription
    end

    it '.expired returns only expired subscriptions' do
      expect(subject.expired).to be_a Array
      expect(subject.expired.first).to be_a Subscription
      expect(subject.expired.count).to be <= subject.count
    end

    it '.active returns only active subscriptions' do
      expect(subject.active).to be_a Array
      expect(subject.active.first).to be_a Subscription
      expect(subject.active.count).to be <= subject.count
    end

    it '.active + .expired = total subscriptions' do
      expect(subject.active.count + subject.expired.count).to eq subject.count
    end

    it '.downloads_left only subscriptions with downloads left' do
      expect(subject.downloads_left).to be_a Array
      expect(subject.downloads_left).to eq subject.select{|sub| sub.has_downloads_left? }
    end

    it '.find_subscription_for_image_size finds subs to use for download of image size' do
      sub = subject.find_subscription_for_image_size("huge")
      expect(sub.id).to eq "s30187600"
      expect(sub.has_downloads_left?).to be true
      expect(sub.allows_image_size_download?("huge")).to be true

      # Defaults to huge when no param
      sub = subject.find_subscription_for_image_size()
      expect(sub.id).to eq "s30187600"

      expect(subject.find_subscription_for_image_size("invalid_size")).to be nil
    end

  end

end
