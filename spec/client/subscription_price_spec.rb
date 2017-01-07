require 'spec_helper'

describe SubscriptionPrice do
  # before do
  #   client
  # end

  context 'initialize' do
    it 'initializes with data from params' do
      subject = SubscriptionPrice.new("local_amount" => 10.40, "local_currency" => "USD")
      expect(subject.local_amount).to eq 10.40
      expect(subject.local_currency).to eq "USD"
    end

  end

end
