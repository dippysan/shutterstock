require 'spec_helper'

describe Client do

  context "#initialize" do
    it "should require a block" do
			expect { Client.instance.configure }.to raise_error(AppNotConfigured)
    end
  end

  context 'basic auth' do
    it 'should raise an exception when client_id is not provided' do
      expect do
				Client.instance.configure do |config|
          config.client_secret = "67890"
          config.access_token = "abcde"
          config.api_url = "https://api.shutterstock.com/v2"
        end
      end.to raise_error(AppNotConfigured)
    end

    it 'should raise an exception when client_secret is not provided' do
      expect do
        Client.instance.configure do |config|
          config.client_id = "12345"
        end
      end.to raise_error(AppNotConfigured)
    end

  end

end
