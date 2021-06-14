# frozen_string_literal: true

require 'httparty'

class SmokeTest
  include HTTParty

  base_uri "#{ENV['APP_SCHEME']}://#{ENV['APP_HOST']}"
  debug_output $stdout

  def initialize(mobile_number:, headers: {})
    @mobile_number, @headers = mobile_number, headers
  end

  def sure_registration_is_working?
    register
    ok_response? || mobile_number_already_exists?
  end

  def sure_sign_in_is_working?
    sign_in
    ok_response?
  end

  private

  def register
    @response = self.class.post('/users', body: sign_up_params, headers: @headers)
  end

  def ok_response?
    @response.code == 200
  end

  def registered?
    ok_response? || mobile_number_already_exists?
  end

  def sign_in
    @response = self.class.post('/login/sms', body: sign_in_params, headers: @headers)
  end

  def mobile_number_already_exists?
    @response.code == 400 && already_exists_message
  end

  def already_exists_message
    @response.parsed_response['message'] == 'User with this mobile_number already exists'
  end

  def sign_up_params
    { user: { mobile_number: @mobile_number } }.to_json
  end

  def sign_in_params
    { to: @mobile_number }.to_json
  end
end
