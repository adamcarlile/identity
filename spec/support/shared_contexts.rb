# frozen_string_literal: true

SMS_BODY_PATTERN = /Your OTP is (\d{6})/.freeze

shared_context :registered_user do
  include_context :sms_transport, mocked: true
  let(:mobile_number) { '+447777888888' }
  let(:signup_payload) { { user: { mobile_number: mobile_number } }.to_json }

  let!(:registered_user) do
    post '/users', params: signup_payload, headers: api_headers
    reset_sms_client
    User.find(JSON(response.body)['id'])
  end
end

shared_context :sms_transport do |mocked: false|
  let(:sms_client) do
    if mocked
      instance_double(SMS::Client).tap do |provider|
        allow(provider).to receive(:send_sms)
      end
    else
      SMS::Client.new(adaptor: SMS::Adaptors::Logger.new(logger: Rails.logger))
    end
  end

  def reset_sms_client
    RSpec::Mocks.space.proxy_for(sms_client).reset
    allow(sms_client).to receive(:send_sms)
  end

  around(:each) do |example|
    original_sms_client = Rails.application.config.sms_client
    example.run
    Rails.application.config.sms_client = original_sms_client
  end

  before :each do
    Rails.application.config.sms_client = sms_client
  end

  let(:invalid_phone_number) { '+15005550001' }
  let(:international_phone_number) { '+15005550003' }

  def extract_otp(message)
    message.match(SMS_BODY_PATTERN).captures[0]
  end
end

shared_context :api_headers do
  let(:api_headers) do
    {
      'CONTENT-TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  end
end

shared_context :oauth do
  include_context :api_headers

  def oauth_payload(mobile_number, otp)
    {
      grant_type: 'password',
      mobile_number: mobile_number,
      password: otp
    }.to_json
  end

  def use_otp(mobile_number, otp)
    post '/oauth/token', params: oauth_payload(mobile_number, otp),
                         headers: api_headers
  end

  def use_access_token(access_token)
    get '/users/me', headers: api_headers.merge('Authorization' => "Bearer #{access_token}")
  end
end

shared_context :clean_env do
  around :each do |spec|
    backup = ENV.to_hash
    spec.call
    ENV.each_key do |key|
      ENV.delete(key)
    end

    backup.each_key do |key|
      ENV[key] = backup[key]
    end
  end
end

shared_context :rack_test_log_recorder do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  let(:log_recorder) { StringIO.new }

  around do |spec|
    backup = Lograge.logger
    Lograge.logger = ActiveSupport::Logger.new(log_recorder)
    spec.run
    Lograge.logger = backup
  end
end
