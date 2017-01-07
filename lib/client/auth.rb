module Shutterstock
	class Auth < Driver

    def self.get_authorize_url(redirect_uri:, scope:, state: 'state_%d' % [Time.now.to_i])
      resp = client.request do |r|
        r.path            "/v2/oauth/authorize"
        r.method          :get
        r.send_authorization  false
        r.success_status  302
        r.params          ({ scope: scope,
                             client_id: client.config.client_id,
                             response_type: 'code',
                             state: state,
                             redirect_uri: redirect_uri })
      end
      redirect_location = resp.headers[:location]
      returned_state = ensure_next_url_contains_sent_state(redirect_location, state)

      redirect_location
    end

    def self.get_access_token(code:, grant_type: 'authorization_code', contributor: 'customer')
      resp = client.request do |r|
        r.path            "/v2/oauth/access_token"
        r.method          :post
        r.send_authorization  false
        r.content_type    'application/x-www-form-urlencoded'
        r.body            ({ grant_type: grant_type,
                             client_id: client.config.client_id,
                             client_secret: client.config.client_secret,
                             code: code,
                             contributor: contributor })
		  end
      resp.body
    end

    private

    def self.ensure_next_url_contains_sent_state(url, state)
      # https://accounts.shutterstock.com/login?next=%2Foauth%2Fauthorize%3Fclient_id%3D<SSTK_CLIENT_ID...
      next_query = CGI.parse(URI.parse(url).query)["next"].first
      # /oauth/authorize?client_id=<SSTK_CLIENT_ID>&redirect_uri=...
      returned_state = CGI.parse(URI.parse(next_query).query)["state"].first
      raise(RuntimeError, "State in redirected url (%s) not identical to sent state (%s)" % [returned_state,state]) unless (returned_state==state)
    end

	end
end
