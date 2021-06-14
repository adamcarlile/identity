if ActiveModel::Type::Boolean.new.cast ENV['SEND_EMAIL']
  action_mailer = Rails.application.config.action_mailer
  action_mailer.delivery_method = :smtp
  
  config = {}
  config[:address]        = ENV['SMTP_ADDRESS']
  config[:port]           = ENV['SMTP_PORT']
  config[:user_name]      = ENV['SMTP_USER_NAME']
  config[:password]       = ENV['SMTP_PASSWORD']
  config[:authentication] = ENV.fetch('SMTP_AUTHENTICATION', :plain).to_sym

  action_mailer.smtp_settings = config.reject { |k,v| v.blank? }
end
