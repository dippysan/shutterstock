module Shutterstock
	class Contributor < Driver
		attr_reader :id

    include Equalizer.new(:id)

		def initialize(params={})
			@hash         = params
			@id           = params["id"].to_i
		end

    # TODO API calls

	end
end
