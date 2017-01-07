module Shutterstock
	class ImageSizeDetails < Driver
    attr_reader :hash, :height, :width, :file_size, :display_name, :dpi, :format, :is_licensable

     # {"display_name":"Huge","dpi":300,"file_size":1103872,"format":"jpg","height":5000,"is_licensable":false,"width":5000}

		def initialize(params = {})
      @hash                       = params
      @height                     = params["height"].to_i if params["height"]       # (integer, optional),
      @width                      = params["width"].to_i if params["width"]         # (integer, optional),
      @file_size                  = params["file_size"].to_i if params["file_size"] # (integer, optional),
      @display_name               = params["display_name"]                          # (string, optional),
      @dpi                        = params["dpi"].to_i if params["dpi"]             # (integer, optional),
      @format                     = params["format"]                                # (string, optional),
      @is_licensable              = json_true? params["is_licensable"]              # (boolean, optional)
    end

    alias_method :name, :display_name

    def licensable?
      @is_licensable
    end


	end
end
