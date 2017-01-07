module Shutterstock
	class SubscriptionAllotment < Driver
		attr_reader :downloads_left, :downloads_limit, :start_time, :end_time

		def initialize(params={})
			@hash                   = params

      @downloads_left         = params["downloads_left"].to_i if params["downloads_left"]             # (integer, optional),
      @downloads_limit        = params["downloads_limit"].to_i if params["downloads_limit"]           # (integer, optional),
      @start_time             = to_date params["start_time"] if params["start_time"]                  # (string, optional),
      @end_time               = to_date params["end_time"] if params["end_time"]                      # (string, optional)
		end

    def has_downloads_left?
      @downloads_left>0
    end

  end
end
