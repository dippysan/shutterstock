require 'spec_helper'

describe SubscriptionAllotment do
  # before do
  #   client
  # end

  context 'initialize' do
    it 'initializes with data from params' do
      subject = SubscriptionAllotment.new("downloads_left" => 10, "downloads_limit" => 30, "start_time" => "2016-12-28T09:36:49-05:00", "end_time" => "2017-12-28T09:36:49-10:00")
      expect(subject.downloads_left).to eq 10
      expect(subject.downloads_limit).to eq 30
      expect(subject.start_time).to eq DateTime.parse("2016-12-28T09:36:49-05:00")
      expect(subject.end_time).to eq DateTime.parse("2017-12-28T09:36:49-10:00")
    end

    it '.has_downloads_left?' do
      subject = SubscriptionAllotment.new("downloads_left" => 10, "downloads_limit" => 30)
      expect(subject.has_downloads_left?).to be true
      subject = SubscriptionAllotment.new("downloads_left" => 0, "downloads_limit" => 30)
      expect(subject.has_downloads_left?).to be false
    end
  end

end
