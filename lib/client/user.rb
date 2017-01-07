module Shutterstock
	class User < Driver
		attr_reader :id, :contributor_id, :customer_id, :email, :first_name, :full_name, :id, :last_name, :language,
                :organization_id, :username, :is_premier, :is_premier_parent, :premier_permissions, :only_sensitive_use,
                :only_enhanced_license

    include Equalizer.new(:id)

		def initialize(params={})
			@hash                   = params
      @contributor_id         = params["contributor_id"] if params["contributor_id"]                  # (string, optional),
      @customer_id            = params["customer_id"] if params["customer_id"]                        # (string, optional),
      @email                  = params["email"] if params["email"]                                    # (string, optional),
      @first_name             = params["first_name"] if params["first_name"]                          # (string, optional),
      @full_name              = params["full_name"] if params["full_name"]                            # (string, optional),
      @id                     = params["id"] if params["id"]                                          # (string, optional),
      @last_name              = params["last_name"] if params["last_name"]                            # (string, optional),
      @language               = params["language"] if params["language"]                              # (string, optional),
      @organization_id        = params["organization_id"] if params["organization_id"]                # (string, optional),
      @username               = params["username"] if params["username"]                              # (string, optional),
      @is_premier             = json_true? params["is_premier"] if params["is_premier"]               # (boolean, optional),
      @is_premier_parent      = json_true? params["is_premier_parent"] if params["is_premier_parent"] # (boolean, optional),
      @premier_permissions    = params["premier_permissions"] if params["premier_permissions"]        # (string[], optional),
      @only_sensitive_use     = json_true? params["only_sensitive_use"] if params["only_sensitive_use"]          # (boolean, optional),
      @only_enhanced_license  = json_true? params["only_enhanced_license"] if params["only_enhanced_license"]    # (boolean, optional)
		end

    # boolean readers
    def premier?
      @is_premier
    end

    # boolean readers
    def premier_parent?
      @is_premier_parent
    end

    # boolean readers
    def sensitive_use?
      @only_sensitive_use
    end

    # boolean readers
    def enhanced_license?
      @only_enhanced_license
    end


    # Currently logged in user
		def self.find
      resp = client.request do
        path            "/v2/user"
        method          :get
      end
      User.new(resp.body)
		end

    # Subscriptions for current user
    def self.subscriptions
      resp = client.request do |r|
        r.path            "/v2/user/subscriptions"
        r.method          :get
      end
      Subscriptions.new(resp.body)
    end

  end
end
