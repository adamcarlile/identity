module SMS
  module Adaptors
    class Test
    
      attr_accessor :messages

      def initialize()
        @messages = []
      end

      def last_message
        messages.last
      end

      def send_sms(to:, message:)
        messages << {to: to, message: message}
      end

    end
  end
end 