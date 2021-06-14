# frozen_string_literal: true

RSpec::Matchers.define :be_a_valid_otp_for do |mobile_number|
  match do |otp|
    use_otp(mobile_number, otp)
    response.status == 200
  end
end
