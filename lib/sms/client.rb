# frozen_string_literal: true

require 'twilio-ruby'

require_relative 'adaptors/twilio'
require_relative 'adaptors/logger'
require_relative 'adaptors/test'

module SMS
  class InvalidDestinationNumber < StandardError
  end
  class ServiceError < StandardError
  end

  class Client

    delegate :send_sms, to: :adaptor

    attr_reader :adaptor

    def initialize(adaptor:)
      @adaptor = adaptor
    end

  end
end
