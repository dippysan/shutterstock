module Shutterstock
	class Category < Driver
		attr_reader :id, :name

    include Equalizer.new(:id)

		def initialize(params={})
			@hash         = params
      @id           = params["id"].to_i
			@name           = params["name"]
		end

    # TODO API calls

	end
end
