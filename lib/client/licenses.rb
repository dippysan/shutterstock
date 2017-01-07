module Shutterstock
	class Licenses < Array
		attr_reader :raw_data, :total_count, :page, :per_page, :message, :errors
		def initialize(raw_data)
			@raw_data = raw_data

			if raw_data.kind_of? Hash
				super(@raw_data["data"].map{ |license| License.new(license) })

        @total_count   = raw_data["total_count"].to_i
        @page          = raw_data["page"].to_i
        @per_page          = raw_data["per_page"].to_i
        @message     = raw_data["message"]
        @errors     = raw_data["errors"]

			elsif raw_data.kind_of? Array
				super( @raw_data.map{ |license| License.new(license) } )
			end

			self
		end
	end
end
