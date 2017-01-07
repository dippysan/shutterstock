module Shutterstock
	class Images < Array
		attr_reader :raw_data, :page, :total_count, :sort_method, :search_id
		def initialize(raw_data)
			@raw_data = raw_data

			if raw_data.kind_of? Hash
				super(@raw_data["data"].map{ |image| Image.new(image) })

				@total_count   = raw_data["total_count"].to_i
				@page          = raw_data["page"].to_i
				# @sort_method   = raw_data["sort_method"]
				@search_id     = raw_data["search_id"]
			elsif raw_data.kind_of? Array
				super( @raw_data.map{ |image| Image.new(image) } )
			end

			self
		end

    # Fill each image in array
    def fill
      self.each {|image| image.fill}
    end

	end
end
