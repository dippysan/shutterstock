module Shutterstock
	class ImageAssets < Driver
    attr_reader :hash, :small_jpg, :medium_jpg, :huge_jpg, :supersize_jpg, :huge_tiff, :supersize_tiff, :vector_eps, :small_thumb, :large_thumb,
                 :preview, :preview_1000, :preview_1500

		def initialize(params = {})
      @hash                       = params
      @small_jpg                  = ImageSizeDetails.new(params["small_jpg"]) if params["small_jpg"]           # (ImageSizeDetails, optional),
      @medium_jpg                 = ImageSizeDetails.new(params["medium_jpg"]) if params["medium_jpg"]         # (ImageSizeDetails, optional),
      @huge_jpg                   = ImageSizeDetails.new(params["huge_jpg"]) if params["huge_jpg"]             # (ImageSizeDetails, optional),
      @supersize_jpg              = ImageSizeDetails.new(params["supersize_jpg"]) if params["supersize_jpg"]   # (ImageSizeDetails, optional),
      @huge_tiff                  = ImageSizeDetails.new(params["huge_tiff"]) if params["huge_tiff"]           # (ImageSizeDetails, optional),
      @supersize_tiff             = ImageSizeDetails.new(params["supersize_tiff"]) if params["supersize_tiff"] # (ImageSizeDetails, optional),
      @vector_eps                 = ImageSizeDetails.new(params["vector_eps"]) if params["vector_eps"]         # (ImageSizeDetails, optional),
      @small_thumb                = Thumbnail.new(params["small_thumb"]) if params["small_thumb"]              # (Thumbnail, optional),
      @large_thumb                = Thumbnail.new(params["large_thumb"]) if params["large_thumb"]              # (Thumbnail, optional),
      @preview                    = Thumbnail.new(params["preview"]) if params["preview"]                      # (Thumbnail, optional),
      @preview_1000               = Thumbnail.new(params["preview_1000"]) if params["preview_1000"]            # (Thumbnail, optional),
      @preview_1500               = Thumbnail.new(params["preview_1500"]) if params["preview_1500"]            # (Thumbnail, optional)
    end

    alias_method :small, :small_jpg
    alias_method :medium, :medium_jpg
    alias_method :huge, :huge_jpg
    alias_method :supersize, :supersize_jpg

    def count
      @hash.keys.count
    end

    def largest_preview
      [preview_1500, preview_1000, preview].compact.first
    end

    def largest_jpg
      [supersize_jpg, huge_jpg, medium_jpg, small_jpg].compact.first
    end

    def largest_tiff
      [supersize_tiff, huge_tiff].compact.first
    end

	end
end












