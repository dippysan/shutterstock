module Shutterstock
	class SubscriptionLicenseFormat < Driver
		attr_reader :description, :min_resolution, :media_type, :format, :size

		def initialize(params={})
			@hash                   = params

      @description            = params["description"] if params["description"]                        # (string, optional),
      @min_resolution         = params["min_resolution"].to_i if params["min_resolution"]             # (integer, optional),
      @media_type             = params["media_type"] if params["media_type"]                          # (string, optional),
      @format                 = params["format"] if params["format"]                                  # (string, optional),
      @size                   = params["size"] if params["size"]                                      # (string, optional)
		end

  end
end
