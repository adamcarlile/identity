# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sessions::Otp::ChallengesController, type: :request do
  describe "GET new" do
    let(:path) { '/otp/challenges/new' }

    before { get path }
    it { expect(response).to be_ok }
  end

  describe "POST create" do

    let(:path)          { '/otp/challenges' }
    let(:mobile_number) { "07590 673597" }
    let(:payload)       { { sessions_otp_challenge_form: { mobile_number: mobile_number } } }
    let(:sms_client)    { Rails.application.config.sms_client }

    context "with a valid user" do
      let!(:user)       { create :user, :verified, mobile_number: "+447590673597" }
      let!(:otp_code)   { user.otp_code(auto_increment: true) }
      
      describe "with valid payload" do
        before { post(path, params: payload) }

        it { expect(response).to be_redirect }
        it { expect(sms_client.adaptor.last_message[:to]).to eql(user.mobile_number.to_s) }
        it { expect(sms_client.adaptor.last_message[:message]).to include(otp_code) }
      end

      describe "with an invalid payload" do
        let(:mobile_number) { "this is not valid"}

        before { post(path, params: payload) }

        it { expect(response).to be_unprocessable }
      end
    end

    context "with an invalid user" do
      before { post(path, params: payload) }

      it { expect(response).to be_unprocessable }
    end
  end

end
