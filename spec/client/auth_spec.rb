require 'spec_helper'

describe Auth do

  before do
    client_no_token
  end

  describe ".get_authorize_url" do
    it 'returns URL to redirect user to, passing redirect url and state' do
      result = Shutterstock::Auth.get_authorize_url(redirect_uri: 'http://localhost',
                                                    state: 'test',
                                                    scope: 'collections.view')
      expect(result).to be_a String
      expect(result).to match /accounts.shutterstock.com\/login/
      expect(result).to match /\%3Dtest/
      expect(result).to match /\%2Flocalhost/
    end
  end

  describe ".get_access_token" do
    it 'returns hash with access token' do
      # Code from here retrieved by running .get_authorize_url, copying url returned into browser then logging in.
      # Redirected to here: http://localhost/?code=Dc4nSMazdKkFtk7AyBkSG3&state=test, and copied code from there
      result = Shutterstock::Auth.get_access_token(code: 'Dc4nSMazdKkFtk7AyBkSG3')
      expect(result).to be_a Hash
      expect(result["access_token"]).to match /v2\//
      expect(result["token_type"]).to eq 'Bearer'
    end

  end

  it "fails if regular api call made without access_token" do
    expect{Image.find(1234)}.to raise_error(AppNotConfigured)
  end
end
