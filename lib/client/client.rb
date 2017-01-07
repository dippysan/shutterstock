require 'faraday'
require 'faraday_middleware'
require 'json'
require 'singleton'

module Shutterstock

  class Client
    include Singleton

    # @return [Configuration] Config instance
    attr_reader :config

    # Request options
    attr_accessor :options

    # Creates a new {Client} instance and yields {#config}.
    # Requires a block to be given.
    def configure
      raise AppNotConfigured, "block not given" unless block_given?

      @config = Configuration.new
      yield config

      @config.api_url ||= "https://api.shutterstock.com/v2"
      raise AppNotConfigured, "Client ID not provided" if config.client_id.nil?
      raise AppNotConfigured, "Client Secret not provided" if config.client_secret.nil?
      # raise AppNotConfigured, "Access Token not provided" if config.access_token.nil? # Not needed for auth requests

      @options = {
        base_uri: config.api_url,
        client_id: config.client_id,
        client_secret: config.client_secret,
        access_token: config.access_token
      }

    end

    def configured?
      !config.nil?
    end

    def connection
      @connection ||= Faraday.new(config.api_url) do |conn|
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
      end
    end

    def request(&block)
      req = Request.new(&block)
      api(req)
    end

    def api(request)

      raise AppNotConfigured, "Access Token not provided" if options[:access_token].nil? && request.send_authorization

      content_type = request.content_type
      response = connection.run_request(request.method, nil, nil, nil) do |req|
        req.url request.path
        req.headers['Authorization'] = 'Bearer '+options[:access_token] if request.send_authorization
        req.headers['Content-Type'] = request.content_type
        req.params = request.params if request.params
        req.body = (content_type =~ /json/ ? request.body.to_json : URI.encode_www_form(request.body)) if request.body
      end
      raise FailedResponse.new("Something went wrong: #{response.status}: #{response.body}", response.status) unless (response.status == request.success_status)
      response
    end

  end
end
