module Otp
  module Challenges
    class CreateService < ServiceObject

      def initialize(form:)
        @form = form
      end

      def call
        fire(:failure, code: 422, message: I18n.t('errors.form.invalid'), type: :unprocessable_entity) and return unless @form.valid?
        fire(:failure, code: 404, message: I18n.t('errors.otp.no_such_user'), type: :not_found) and return if user.blank?
        Otp::DispatchService.run!(resource: user)
        fire :success, user
      end

      private

      def user
        @user ||= User.find_by(mobile_number: @form.mobile_number)
      end

    end
  end
end
