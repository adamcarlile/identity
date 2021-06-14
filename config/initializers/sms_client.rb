# frozen_string_literal: true

require 'sms/client'

adaptor = if ActiveModel::Type::Boolean.new.cast ENV['SEND_SMS']
            SMS::Adaptors::Twilio.new(
              sid: ENV['TWILIO_ACCOUNT_SID'],
              auth_token: ENV['TWILIO_AUTH_CODE'],
              from: ENV['TWILIO_NUMBER']
            )
          else
            SMS::Adaptors::Logger.new(
              logger: Rails.logger
            )
          end

Rails.application.config.sms_client = SMS::Client.new(adaptor: adaptor)
