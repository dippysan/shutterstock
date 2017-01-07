require 'webmock'
require 'vcr'
require 'rspec'
require 'pry'

require 'shutterstock'
include Shutterstock

DEFAULTS = {
  SSTK_CLIENT_ID: 'client_id',
  SSTK_CLIENT_SECRET: 'client_secret',
  SSTK_ACCESS_TOKEN: 'access_token',
  SSTK_BASE_API_URI: 'https://api.shutterstock.com/v2'
}

def sensitive_data(c, env_key)
  c.filter_sensitive_data("<#{env_key}>") do
    ENV[env_key.to_s] || DEFAULTS[env_key]
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true

  # Errors for any requests with '99999' in them
  c.before_http_request do |request|
    raise FailedResponse.new("uri forced failure") if request.uri =~ /99999/
  end
  sensitive_data(c, :SSTK_CLIENT_ID)
  sensitive_data(c, :SSTK_CLIENT_SECRET)
  sensitive_data(c, :SSTK_ACCESS_TOKEN)

  # returned by shutterstock in cassettes, but is private
  sensitive_data(c, :SSTK_USER_ID)
  sensitive_data(c, :SSTK_USERNAME)
  sensitive_data(c, :SSTK_FULL_NAME)
  sensitive_data(c, :SSTK_FIRST_NAME)
  sensitive_data(c, :SSTK_LAST_NAME)
  sensitive_data(c, :SSTK_CUSTOMER_ID)

end

if ENV['VCR_OFF']
  WebMock.allow_net_connect!
  VCR.turn_off!(ignore_cassettes: true)
end

uri_without_access_token = VCR.request_matchers.uri_without_param(:access_token)

RSpec.configure do |config|
  # Add VCR to all tests
  config.around(:each) do |example|
    options = example.metadata[:vcr] || {}
    options[:match_requests_on] = [:method, uri_without_access_token]
    #options[:record] = :new_episodes # uncomment when updating existing tests
    if options[:record] == :skip
      VCR.turned_off(&example)
    else
      name = example.metadata[:full_description]
        .split(/\s+/, 2).join('/')
        .gsub(/[^\w\/]+/, '_')[0..90]
      VCR.use_cassette(name, options, &example)
    end
  end
end

def client
  Client.instance.configure do |config|
    config.client_id = ENV['SSTK_CLIENT_ID'] || "client_id"
    config.client_secret = ENV['SSTK_CLIENT_SECRET'] || "client_secret"
    config.access_token = ENV['SSTK_ACCESS_TOKEN'] || "access_token"
  end
  Client.instance
end


def client_no_token
	Client.instance.configure do |config|
		config.client_id = ENV['SSTK_CLIENT_ID'] || "client_id"
    config.client_secret = ENV['SSTK_CLIENT_SECRET'] || "client_secret"
	end
	Client.instance
end


