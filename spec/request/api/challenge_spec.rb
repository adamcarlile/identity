# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Otp::ChallengesController, type: :request do
  describe "POST create" do
    let(:application) { create :doorkeeper_application }
    let(:token)       { create :access_token, application: application, scopes: "challenges:write" }
    let(:path)        { "/api/otp/challenges" }

    before do
      post(path, params: payload, headers: { "Authorization": "Bearer #{token.token}" })
    end

    context "with an existing user" do
      let(:user)       { create :user, :verified, mobile_number: "+447590673597" }
      let(:payload) do
        {
          user: {
            mobile_number: user.mobile_number
          }
        }
      end

      describe "with valid payload" do
        it "returns a successful response" do
          expect(response).to be_ok
          parsed_response = parse_response response
          expect(parsed_response[:response_url]).not_to be_blank
        end
      end

      describe "with an invalid payload" do
        let(:payload) do
          {
            user: {
              mobile_number: 'random string'
            }
          }
        end

        it 'returns an unprocessable response' do
          expect(response).to be_unprocessable
          parsed_response = parse_response response
          expect(parsed_response).to eq(
            code: 422,
            message: "Sorry, those details are invalid, please check the errors below.",
            type: "unprocessable_entity"
          )
        end
      end
    end

    context "with a non existing user" do
      let(:payload) do
        {
          user: {
            mobile_number: Faker::PhoneNumber.phone_number
          }
        }
      end

      it "returns a user not found response" do
          expect(response).to be_not_found
          parsed_response = parse_response response
          expect(parsed_response).to eq(
            code: 404,
            message: "Sorry a user with that number doesn't exist, please register first.",
            type: "not_found"
          )
      end
    end
  end
end
