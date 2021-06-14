module Sessions
  module Otp
    class ResponsesController < SessionsController
      before_action :redirect_home, if: :logged_in?

      def new
        redirect_to(new_sessions_otp_challenges_path, alert: I18n.t('errors.otp.expired_session')) and return if resource.blank?
        @form = Sessions::Otp::ResponseForm.new(mobile_number: resource.mobile_number)
      end

      def create
        super
      end

      private

      def permitted_params
        params.require(:credentials).permit(:mobile_number, :otp_i1, :otp_i2, :otp_i3, :otp_i4, :otp_i5, :otp_i6)
      end

      def resource
        @resource ||= GlobalID::Locator.locate_signed(params[:id])
      end
      helper_method :resource

      def form
        @form ||= Sessions::Otp::ResponseForm.new(permitted_params)
      end
      helper_method :form

    end
  end
end