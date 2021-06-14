# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Registrations::CreateService do
  let(:first_name)    { Faker::Name.first_name }
  let(:last_name)     { Faker::Name.last_name }
  let(:postcode)      { Faker::Address.postcode }
  let(:mobile_number) { "+447590673597" }
  let(:email)         { Faker::Internet.email name: [first_name, last_name].join(' ') }
  let(:payload)       { { first_name: first_name, last_name: last_name, postcode: postcode, mobile_number: mobile_number, email: email} }
  let(:form)          { RegistrationForm.new(payload) }
  let(:response)      { spy("response") }
  let(:exists)        { false }

  before do 
    create :user, mobile_number: mobile_number if exists
    described_class.run!(form: form) do |on|
      on.success {|service, user| response.success(user) }
      on.failure {|service, message| response.failure(message) }
    end
  end

  describe "With valid form input" do
    it { 
      expect(response).to have_received(:success) do |user|
        expect(user).to be_persisted
      end 
    }

    describe "It should trigger an OTP dispatch" do
      let(:sms_client)    { Rails.application.config.sms_client }

      it { expect(sms_client.adaptor.last_message[:to]).to eql(mobile_number) }
    end
  end

  describe "With invalid form input" do
    let(:mobile_number) { nil }

    it { expect(response).to have_received(:failure) }
  end

  describe "With a duplicate user" do
    let(:exists) { true }

    it { expect(response).to have_received(:failure) }
  end

end