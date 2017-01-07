require 'date'

module Shutterstock
	class Driver

		def respond_to(method)
			return true if @hash[method.to_s]
			super()
		end

		def methods
			methods = super()
			[methods, @hash.keys.map{ |k| k.to_sym} ].flatten
		end

		TRUTHY_JSON_VALUES = [ "1", 1, true, "true"]
		def json_true?(thing)
			TRUTHY_JSON_VALUES.include? thing
		end

    def to_date(text_date)
      return nil if text_date.nil?
      DateTime.parse(text_date)
    end

		def client
			Client.instance
		end

		def self.client
			Client.instance
		end

    def self.api(*params)
      client.api(*params)
    end
	end
end
