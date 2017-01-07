module Shutterstock
  class Request

    attr_writer   :method,          # :post, :get etc
                  :path,            # request path /v2/images
                  :success_status,  # response code signifying success. Defaults to 200
                  :send_authorization, # default true. Set to false when requesting credentials
                  :content_type,    # default 'application/json'
                  :body,            # hash of parameters for request body (usually for :post)
                  :params           # hash of parameters for url params section (usually for :get or :delete)

    def initialize(&block)
      @success_status = 200
      @send_authorization = true
      @content_type = 'application/json'

      # Handle both forms of config:
      # Request.new { |r| r.method=... }
      # Request.new { method=... }
      if block_given?
        if block.arity == 1
          yield self
        else
          instance_eval(&block)

        end
      end
    end

    # DSL
    %w[method path success_status params body options send_authorization content_type].each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{method}(new_value = nil)
          @#{method} = new_value unless new_value.nil?
          @#{method}
        end
      RUBY
    end

  end
end
