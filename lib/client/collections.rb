module Shutterstock
	class Collections < Array
		attr_reader :raw_data
		def initialize(raw_data)
			@raw_data = raw_data

			if raw_data.kind_of? Hash
				super(@raw_data["data"].map{ |collection| Collection.new(collection) })
			elsif raw_data.kind_of? Array
				super( @raw_data.map{ |collection| Collection.new(collection) } )
			end

			self
		end
	end
end
