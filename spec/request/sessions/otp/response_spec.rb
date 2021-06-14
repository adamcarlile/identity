# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sessions::Otp::ResponsesController, type: :request do
  describe "GET new" do
    let(:path) { '/otp/responses/new' }

    describe "without a secure id in the path" do
      before { get path }

      it { expect(response).to be_not_found }
    end

    describe "coming from the challenge, with the number in the session" do
      let(:mobile_number) { "+447590673597" }
      let(:payload)       { { sessions_otp_challenge_form: { mobile_number: mobile_number } } }
      let!(:user)         { create :user, :verified, mobile_number: mobile_number }

      before do
        post '/otp/challenges', params: payload
        follow_redirect!
      end

      it { expect(response).to be_ok }
      it { expect(response.body).to include(mobile_number) }
    end
  end

  describe "POST create" do
    let(:path)              { "/otp/responses/#{secure_id}" }
    let(:mobile_number)     { "+447590673597"}
    let(:secure_id)         { user.to_sgid.to_s }
    let!(:user)             { create :user, mobile_number: mobile_number }
    let(:one_time_password) { user.otp_code }
    let(:otp_payload)       { one_time_password.chars.map.with_index {|n, i| ["otp_i#{i+1}".to_sym, n]}.to_h }
    let(:payload)           { { credentials: { mobile_number: mobile_number }.merge(otp_payload) } }

    before { post path, params: payload }

    it { expect(response).to be_redirect }
    it { expect(user.verified?(:mobile_number)).to be_truthy }

    describe "Invalid number and OTP" do
      let(:bad_mobile)        { Faker::Base.numerify("+44#{Faker::PhoneNumber.cell_phone}".gsub(" ", "")) }
      let(:one_time_password) { "123456" }
      let(:payload)           { { credentials: { mobile_number: bad_mobile } } }

      it { expect(response).to be_unprocessable }
      it { expect(user.verified?(:mobile_number)).to be_falsey }
    end
  end
end
