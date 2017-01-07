module Shutterstock
	class Models < Array
		attr_reader :raw_data
		def initialize(raw_data)
			@raw_data = raw_data
  		super( @raw_data.map{ |model| Model.new(model) } )
			self
		end

	end
end
