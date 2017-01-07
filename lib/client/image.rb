module Shutterstock
	class Image < Driver
    attr_reader :hash, :id, :description, :added, :media_type, :contributor, :aspect, :image_type, :is_editorial,
                :is_adult, :is_illustration, :has_model_release, :has_property_release, :model_releases, :categories,
                :keywords, :assets, :models

    include Equalizer.new(:id)

# {"id":"118139110",
#   "added_date":"2012-11-09",
#   "aspect":1.5,
#   "assets":{"small_jpg":{"display_name":"Small","dpi":72,"file_size":88064,"format":"jpg","height":333,"is_licensable":true,"width":500},
#             "medium_jpg":{"display_name":"Med","dpi":300,"file_size":301056,"format":"jpg","height":667,"is_licensable":true,"width":1000},
#             "huge_jpg":{"display_name":"Huge","dpi":300,"file_size":2790400,"format":"jpg","height":3090,"is_licensable":true,"width":4635},
#             "supersize_jpg":{"display_name":"Super","dpi":300,"file_size":10112609,"format":"jpg","height":6180,"is_licensable":false,"width":9270},
#             "huge_tiff":{"display_name":"Huge","dpi":300,"file_size":42966450,"format":"tiff","height":3090,"is_licensable":false,"width":4635},
#             "supersize_tiff":{"display_name":"Super","dpi":300,"file_size":171865800,"format":"tiff","height":6180,"is_licensable":false,"width":9270},
#             "preview":{"height":300,"url":"https://image.shutterstock.com/display_pic_with_logo/1306729/118139110/stock-photo-adorable-labrador-puppy-playing-with-a-chew-toy-on-white-backdrop-118139110.jpg","width":450},
#             "small_thumb":{"height":67,"url":"https://thumb1.shutterstock.com/thumb_small/1306729/118139110/stock-photo-adorable-labrador-puppy-playing-with-a-chew-toy-on-white-backdrop-118139110.jpg","width":100},
#             "large_thumb":{"height":100,"url":"https://thumb1.shutterstock.com/thumb_large/1306729/118139110/stock-photo-adorable-labrador-puppy-playing-with-a-chew-toy-on-white-backdrop-118139110.jpg","width":150}
#             },
#   "categories":[{"id":"1","name":"Animals/Wildlife"},{"id":"20","name":"NOT-CATEGORIZED"}],
#   "contributor":{"id":"1306729"},
#   "description":"Adorable Labrador Puppy Playing with a Chew Toy on White Backdrop",
#   "image_type":"photo",
#   "is_adult":false,
#   "keywords":["animal","animal themes","backgrounds","cute","dog","domestic animals","friendship","full length","isolated"],
#   "media_type":"image"}

		def initialize(params = {})
      load_ivars(params)
		end

    def load_ivars(params)
      @hash                       = params
      @id                         = params["id"].to_i
      @description                = params["description"]
      @added                      = to_date(params["added_date"])
      @media_type                 = params["media_type"]
      @contributor                = Contributor.new(params["contributor"]) if params["contributor"]
      @aspect                     = params["aspect"]
      @image_type                 = params["image_type"]
      @is_editorial               = json_true? params["is_editorial"]
      @is_adult                   = json_true? params["is_adult"]
      @is_illustration            = json_true? params["is_illustration"]
      @has_model_release          = json_true? params["has_model_release"]
      @has_property_release       = json_true? params["has_property_release"]
      @model_releases             = params["model_releases"]
      @categories                 = Categories.new(params["categories"]) if params["categories"]
      @keywords                   = params["keywords"]
      @assets                     = ImageAssets.new(params["assets"]) if params["assets"]
      @models                     = Models.new(params["models"]) if params["models"]
    end

		# boolean readers
    def editorial?
      @is_editorial
    end

    def adult?
      @is_adult
    end

    def illustration?
      @is_illustration
    end

    def model_release?
      @has_model_release
    end

    def property_release?
      @has_property_release
    end



		def self.find(id)
      resp = client.request do |r|
        r.path            "/v2/images/#{id}"
        r.method          :get
      end
			self.new(resp.body)
		end

		def find
			self.class.find(self.id)
		end

		def self.similar(id)
      resp = client.request do |r|
        r.path            "/v2/images/#{id}/similar"
        r.method          :get
      end
			Images.new(resp.body)
		end

		def similar
			@images = self.class.similar(self.id)
		end

    def self.search(search)
      search_params = {}
      if search.kind_of? String
        search_params[:query] = search
      else
        search_params = search
      end

      resp = client.request do |r|
        r.path            "/v2/images/search"
        r.method          :get
        r.params          search_params
      end
      Images.new(resp.body)
    end

    # Fetch all details of this image
    def fill
      load_ivars(find.hash)
      self
    end

    # License current image with available subscription
    def license(format: nil, size: nil)
      sub = find_subscription_for_this_size(size)
      License.license(subscription_id: sub.id, image_id: self, format: format, size: size, editorial_acknowledgement: (editorial? ? true : nil))
    end

    private

    def find_subscription_for_this_size(size = nil)
      User.subscriptions.find_subscription_for_image_size
    end



	end
end
