module Shutterstock
	class SubscriptionPrice < Driver
		attr_reader :local_amount, :local_currency

		def initialize(params={})
			@hash                   = params

      @local_amount           = params["local_amount"].to_f if params["local_amount"]                 # (number, optional),
      @local_currency         = params["local_currency"] if params["local_currency"]                  # (string, optional)
		end

  end
end
