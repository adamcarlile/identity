module Exceptions
  class Unauthenticated < StandardError

    def code
      :unauthorized
    end

    def message
      super == self.class.to_s ? 'Unable to authenticate those credentials' : super
    end

  end
end