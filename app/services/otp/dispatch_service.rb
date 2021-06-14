# frozen_string_literal: true

module Otp
  class DispatchService < ServiceObject

    def initialize(sms_client: Rails.application.config.sms_client, resource:)
      @sms_client = sms_client
      @resource = resource
    end

    def call
      @resource.save!
      @sms_client.send_sms(
        to: @resource.mobile_number.to_s,
        message: I18n.t('messages.otp_dispatcher.success', otp_code: @resource.otp_code(auto_increment: true))
      )
      @resource.update!(otp_created_at: Time.current)

      fire :success, @resource
    end

  end
end
