# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Otp::Challenges::CreateService do
  let(:mobile_number) { "07590 673597" }
  let(:payload)       { { mobile_number: mobile_number } }
  let(:form)          { Sessions::Otp::ChallengeForm.new(payload) }
  let(:sms_client)    { Rails.application.config.sms_client }
  let(:response)      { spy("response") }
  let(:exists)        { true }

  before do
    create :user, mobile_number: form.mobile_number if exists
    described_class.run!(form: form) do |on|
      on.success {|service, user| response.success(user) }
      on.failure {|service, message| response.failure(message) }
    end
  end

  describe "With a valid input" do
    it { expect(response).to have_received(:success) }
    it { expect(sms_client.adaptor.last_message[:to]).to eql(form.mobile_number.to_s) }
  end

  describe "With invalid input" do
    let(:mobile_number) { Faker::Name.first_name }

    it { expect(response).to have_received(:failure) }
  end

  describe "With a missing user" do
    let(:exists) { false }

    it { expect(response).to have_received(:failure) } 
  end

end