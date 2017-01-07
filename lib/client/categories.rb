module Shutterstock
	class Categories < Array
		attr_reader :raw_data
		def initialize(raw_data)
			@raw_data = raw_data
  		super( @raw_data.map{ |cat| Category.new(cat) } )
			self
		end

	end
end
