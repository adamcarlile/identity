module SMS
  module Adaptors
    class Logger
    
      def initialize(logger: Rails.logger)
        @logger = logger
      end

      def send_sms(to:, message:)
        @logger.info "#" * 100
        @logger.info "# To: #{to}"
        @logger.info "# Message: #{message}"
        @logger.info "#" * 100
      end

    end
  end
end 