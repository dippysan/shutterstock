module Shutterstock
	class License < Driver
		attr_reader :image_id, :allotment_charge, :price, :download, :error

    include Equalizer.new(:id)

		def initialize(params={})
			@hash                 = params
      @image_id             = params["image_id"].to_i                                       # (string),
      @allotment_charge     = params["allotment_charge"].to_i if params["allotment_charge"] # (integer, optional),
      @price                = SubscriptionPrice.new(params["price"]) if params["price"]     # (Price, optional): Wholesale price information, (for rev-share partners only),
      @download             = params["download"]["url"] if params["download"]               # (Url, optional): Information needed to download the image,
      @error                = params["error"] if params["error"]                            # (string, optional)
		end

    alias_method :id, :image_id

    # image_id is an array of either
    #  - integer (which is translated to {image_id: "999"} for call)
    #  - Image object (which is translated to {image_id: "999"} for call)
    #  - hash (passed straight through - used when including metadata: {image_id: "999", metadata: {}}
    def self.license_multiple(subscription_id:, image_id:, format: nil, size: nil, editorial_acknowledgement: nil)

      raise ArgumentError, "format of 'eps' must correspond with size of 'vector'" if format=='eps' and size != 'vector'

      params = {}
      params[:subscription_id] = subscription_id
      params[:format] = format if format
      params[:size] = size if size

      resp = client.request do |r|
        r.path            "/v2/images/licenses?subscription_id=#{subscription_id}"
        r.method          :post
        r.params          params
        r.body            ({images: image_ids_to_array_of_hash(image_id, editorial_acknowledgement)})
      end
      Licenses.new(resp.body)
    end


		def self.license(subscription_id:, image_id:, format: nil, size: nil, editorial_acknowledgement: nil)
      return license_multiple(subscription_id: subscription_id, image_id: [image_id], format: format, size: size, editorial_acknowledgement: editorial_acknowledgement).first
    end


    private

    # for post request
    # image_id from [1,Image.new("id" => 2), {"image_id" => 3, "metadata": {}}] => [{image_id: "1"},{image_id: "2"},{image_id: "3", metadata: {}}]
    def self.image_ids_to_array_of_hash(image_ids, editorial_acknowledgement)
      Array(image_ids).map do |iid|
        hash = case iid
                when Image
                  hash = { "image_id" => iid.id.to_s }
                when Integer
                  { "image_id" => iid.to_s }
                when Hash
                  iid
                end
        hash["editorial_acknowledgement"] = true if editorial_acknowledgement
        hash
      end
    end


	end
end
