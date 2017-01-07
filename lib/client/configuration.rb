module Shutterstock
	class Configuration
		# @return [String] The client id.
		attr_accessor :client_id

		# @return [String] The client secret.
		attr_accessor :client_secret

		# @return [String] The access token.
		attr_accessor :access_token

		# @return [String] The API url.
		attr_accessor :api_url

		def initialize
			@client_options = {}
		end

	end
end
