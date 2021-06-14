# frozen_string_literal: true

# Mute logging to local log folder, to avoids filling up disk in the cloud)
logger = ActiveSupport::Logger.new('/dev/null')
logger.formatter = Rails.application.config.log_formatter
Rails.logger = ActiveSupport::TaggedLogging.new(logger)

Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.logger = ActiveSupport::Logger.new(STDOUT)
  config.lograge.formatter = Lograge::Formatters::Json.new

  config.lograge.custom_payload do |controller|
    # TODO: These lines are covered by lograge_spec.rb however simplecov can't see it
    # :nocov:
    { params: controller.params.as_json, response_length: controller.response.body.length }
    # :nocov:
  end
end
