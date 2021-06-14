# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Otp::DispatchService do
  let(:user)        { create :user }
  let(:sms_client)  { Rails.application.config.sms_client }
  let(:response)    { spy("response") }

  before do 
    described_class.run!(resource: user) do |on|
      on.success {|service, user| response.success(user) }
      on.failure {|service, message| response.failure(message) }
    end
  end

  describe "With a valid input" do
    it { expect(sms_client.adaptor.last_message[:to]).to eql(user.mobile_number.to_s)  }
    it { expect(user.otp_created_at).to be_within(1.second).of(Time.now) }
    it { expect(response).to have_received(:success) { |user| expect(user).to eql(user) } }
  end

end