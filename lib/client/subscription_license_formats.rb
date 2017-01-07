module Shutterstock
	class SubscriptionLicenseFormats < Array
		attr_reader :raw_data
		def initialize(raw_data)
			@raw_data = raw_data

      super( @raw_data.map{ |slf| SubscriptionLicenseFormat.new(slf) } )

			self
		end
	end
end
