module Sessions
  module Otp
    class ChallengesController < SessionsController

      def new
        @form = Sessions::Otp::ChallengeForm.new
      end

      def create
        ::Otp::Challenges::CreateService.run!(form: form) do |on|
          on.success do |service, user|
            redirect_to new_sessions_otp_responses_path(id: user.to_sgid(expires_in: 10.minutes))
          end
          on.failure do |service, message|
            flash.now[:alert] = message
            render :new, status: :unprocessable_entity
          end
        end
      end

      private

      def permitted_params
        params.require(:sessions_otp_challenge_form).permit(:mobile_number)
      end

      def form
        @form ||= Sessions::Otp::ChallengeForm.new(permitted_params)
      end
      helper_method :form

    end
  end
end