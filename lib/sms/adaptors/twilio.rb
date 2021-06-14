require_relative '../../integration/twilio/error_codes'

module SMS
  module Adaptors
    class Twilio
      include Integration::Twilio::ErrorCodes

      INVALID_NUMBER_ERRORS = [INVALID_FORMAT,
                               UNROUTABLE,
                               INCAPABLE_OF_SMS].freeze

      attr_reader :from, :error_codes, :client

      def initialize(sid:, auth_token:, from:, error_codes: INVALID_NUMBER_ERRORS)
        @from = from
        @error_codes = error_codes
        @client = ::Twilio::REST::Client.new sid, auth_token
      end

      def send_sms(to:, message: )
        client.messages.create(
          body: message,
          to: to,
          from: from
        )
      rescue ::Twilio::REST::RestError => e
        raise SMS::InvalidDestinationNumber if error_codes.include?(e.code)
  
        raise SMS::ServiceError.new, e.message
      end
      
    end
  end
end