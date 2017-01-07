module Shutterstock
  class Subscriptions < Array
    attr_reader :raw_data, :page, :total_count, :sort_method, :search_id
    def initialize(raw_data)
      @raw_data = raw_data

      if raw_data.kind_of? Hash
        super(@raw_data["data"].map{ |subscription| Subscription.new(subscription) })

        @total_count   = raw_data["total_count"].to_i
        @page          = raw_data["page"].to_i
      elsif raw_data.kind_of? Array
        super( @raw_data.map{ |subscription| Subscription.new(subscription) } )
      end

      self
    end

    def find_subscription_for_image_size(size = nil)
      size = "huge" if !size
      self.active.select{|sub| sub.has_downloads_left? && sub.allows_image_size_download?(size)}.first
    end

    def downloads_left
      self.select{|sub| sub.has_downloads_left?}
    end

    def expired
      self.select{|sub| sub.expired?}
    end

    def active
      self.reject{|sub| sub.expired?}
    end

  end
end
