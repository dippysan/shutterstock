module Shutterstock
	class Collection < Driver
		attr_reader :id, :name, :share_url, :share_code, :total_count, :created, :updated, :items_updated, :cover_item, :hash

    include Equalizer.new(:id)

		def initialize(params={})
			@hash         = params
			@id           = params["id"].to_i
			@name         = params["name"]
      @share_code   = params["share_code"]
			@share_url    = params["share_url"]
      @total_count  = params["total_item_count"].to_i
      @created      = to_date(params["created_time"])
      @updated      = to_date(params["updated_time"])
      @items_updated = to_date(params["items_updated_time"])
      @cover_item   = Image.new(params["cover_item"]) if params["cover_item"]
		end

		def self.find(id)
      resp = client.request do
        path "/v2/images/collections/#{id}"
        method :get
      end
      self.new(resp.body)
		end

		def find
			self.class.find(self.id)
		end

    def self.create(name)
      raise IncorrectArguments, "collection name not provided" unless name

      resp = client.request do |r|
        r.path            "/v2/images/collections"
        r.method          :post
        r.body            ({ name: name })
        r.success_status  201
      end

      resp_hash = resp.body
      resp_hash.merge!("name" => name)
      self.new(resp_hash)
    end

		def self.list
      resp = client.request do
        path            "/v2/images/collections"
        method          :get
      end
      Collections.new(resp.body)
		end

		def self.update(id:, name:)
			raise IncorrectArguments, "collection name not provided" unless name

      resp = client.request do |r|
        r.path            "/v2/images/collections/#{id}"
        r.method          :post
        r.body            ({ name: name })
        r.success_status  204
      end
    end

    def self.destroy(id)
      resp = client.request do |r|
        r.path            "/v2/images/collections/#{id}"
        r.method          :delete
        r.success_status  204
      end
      nil
    end

    def destroy
      self.class.destroy(self.id)
		end

		# collection.add_image({collection_id: 1234556, image_id: 98765432})
		def self.add_image(id:, image_id:)

			raise IncorrectArguments, "collection id not provided" unless id
			raise IncorrectArguments, "image id not provided" unless image_id

      resp = client.request do |r|
        r.path            "/v2/images/collections/#{id}/items"
        r.method          :post
        r.body            ({ items: image_ids_to_array_of_hash(image_id)})
        r.success_status  204
      end
      self
    end

    # image_id can be a single or array of either image ids or Image objects
    def add_image(image_id)
      self.class.add_image({id: self.id, image_id: image_id})
    end

    def self.remove_image(id:, image_id:)

      resp = client.request do |r|
        r.path            "/v2/images/collections/#{id}/items"
        r.method          :delete
        r.params          image_ids_to_hash_of_array(image_id)
        r.success_status  204
      end
      self
		end

		def remove_image(image_id)
			self.class.remove_image(id: self.id, image_id: image_id)
		end

    def self.items(id)
      raise IncorrectArguments, "collection id not provided" unless id

      resp = client.request do |r|
        r.path            "/v2/images/collections/#{id}/items"
        r.method          :get
      end
      Images.new(resp.body["data"])
    end

    def items
      self.class.items(self.id)
    end



    private

    # for post request
    # image_id from [1,2,Image.new("id" => 3)] => [{id: "1"},{id: "2"},{id: "3"}]
    # from 1 => [{id: "1"}]
    # from Image.new("id" => 1) => [{id: "1"}]
    def self.image_ids_to_array_of_hash(image_ids)
      Array(image_ids).map{|iid| { id: (iid.is_a?(Image) ? iid.id : iid).to_s} }
    end
    # for delete request
    # image_id from [1,2,Image.new("id" => 3)] => {id: [1,2,3]}
    # from 1 => {id: 1}
    # from Image.new("id" => 1) => {id: 1}
    def self.image_ids_to_hash_of_array(image_ids)
      if image_ids.is_a? Array
        {id: image_ids.map{|iid| iid.is_a?(Image) ? iid.id : iid}}
      else
        {id: image_ids.is_a?(Image) ? image_ids.id : image_ids}
      end
    end
	end
end
