require 'date'

module Shutterstock
	class Subscription < Driver
		attr_reader :id, :description, :expiration_time, :price_per_download, :license, :allotment, :formats, :metadata

    include Equalizer.new(:id)

		def initialize(params={})
			@hash                   = params
      @id                     = params["id"]                                                          # (string),
      @description            = params["description"] if params["description"]                        # (string, optional),
      @expiration_time        = to_date params["expiration_time"] if params["expiration_time"]        # (string, optional),
      @price_per_download     = SubscriptionPrice.new(params["price_per_download"]) if params["price_per_download"]     # (Price, optional),
      @license                = params["license"] if params["license"]                                # (string, optional),
      @allotment              = SubscriptionAllotment.new(params["allotment"]) if params["allotment"] # (Allotment, optional),
      @formats                = SubscriptionLicenseFormats.new(params["formats"]) if params["formats"] # (LicenseFormat[], optional),
      @metadata               = params["metadata"] if params["metadata"]                              # (SubscriptionMetadata, optional)
		end

    def expired?
      @expiration_time<DateTime.now
    end

    # True if this subscription can handle the size passed eg "small"
    def allows_image_size_download?(size)
      !!(!expired? && formats.find {|format| format.size == size})
    end

    def has_downloads_left?
      allotment && allotment.has_downloads_left?
    end

  end
end
