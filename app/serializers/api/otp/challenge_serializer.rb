module Api
  module Otp
    class ChallengeSerializer < SimpleDelegator
      include Swagger::Blocks

      swagger_schema :OtpChallenge do
        key :required, [:response_url]
        property :response_url do
          key :type, :string
          key :format, :uri
        end
      end

      def initialize(user, context)
        @context = context
        super(user)
      end
  
      attr_reader :context
  
      delegate :new_sessions_otp_responses_url, to: :context

      def as_json
        {
          response_url: new_sessions_otp_responses_url(id: secure_id)
        }
      end

      private

      def secure_id
        to_sgid(expires_in: 10.minutes)
      end

    end
  end
end