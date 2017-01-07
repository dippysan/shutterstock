module Shutterstock
  class Error < StandardError
  end

  class IncorrectArguments < Error
  end

  class AppNotConfigured < Error
  end

  class FailedResponse < Error
    attr_reader :code
    alias :msg :message
    def initialize(msg, code = 0)
      @code = code
      super(msg)
    end
  end

end
