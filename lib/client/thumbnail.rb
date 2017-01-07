module Shutterstock
	class Thumbnail < Driver
    attr_reader :hash, :url, :height, :width

    include Equalizer.new(:url)

     # {"display_name":"Huge","dpi":300,"file_size":1103872,"format":"jpg","height":5000,"is_licensable":false,"width":5000}

		def initialize(params = {})
      @hash                       = params
      @url                        = params["url"]         # (string),
      @height                     = params["height"].to_i # (integer),
      @width                      = params["width"].to_i  # (integer)
    end

	end
end
