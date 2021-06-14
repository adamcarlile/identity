# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::InvitationsController, type: :request do
  let(:application) { create :doorkeeper_application }
  let(:token)       { create :access_token, application: application, scopes: "invitations:write" }
  let(:path)        { "/api/invitations" }

  describe "POST /invitations" do
    before do
      post(path, params: payload, headers: { "Authorization": "Bearer #{token.token}" })
    end

    describe "with a valid payload" do
      context "with a new user" do
        let(:payload) do
          {
            redirect_uri: Faker::Internet.url,
            user: {
              email: Faker::Internet.email,
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              mobile_number: Faker::PhoneNumber.cell_phone
            }
          }
        end

        it "returns a new unconsumed invitation url" do
          expect(response).to be_ok
          parsed_response = parse_response response
          expect(parsed_response).to have_key(:id)
          expect(parsed_response).to have_key(:user_id)
          expect(parsed_response).to have_key(:invitation_url)
          expect(parsed_response[:state]).to eq('available')
        end

      end

      context "with an existing user" do
        let!(:invitation) { create :user_invitation }

        let(:user) { invitation.user }
        let(:payload) do
          {
            redirect_uri: Faker::Internet.url,
            user: {
              email: invitation.user.email,
              first_name: invitation.user.first_name,
              last_name: invitation.user.last_name,
              mobile_number: invitation.user.mobile_number
            }
          }
        end

        it "creates a new invitation for an existing user" do
          expect(response).to be_ok
          parsed_response = parse_response response
          expect(parsed_response).to have_key(:id)
          expect(parsed_response).to have_key(:user_id)
          expect(parsed_response).to have_key(:invitation_url)
          expect(parsed_response[:state]).to eq('available')
        end

        context "with a different #email than the one originally registered" do
          let(:payload) do
            {
              redirect_uri: Faker::Internet.url,
              user: {
                email: Faker::Internet.email,
                first_name: invitation.user.first_name,
                last_name: invitation.user.last_name,
                mobile_number: invitation.user.mobile_number
              }
            }
          end

          it "finds the user by #mobile_number" do
            expect(response).to be_ok
            parsed_response = parse_response response
            expect(parsed_response[:user_id]).to eq(user.id)
          end
        end

        context "with a different #mobile_number than the one originally registered" do
          let(:payload) do
            {
              redirect_uri: Faker::Internet.url,
              user: {
                email: invitation.user.email,
                first_name: invitation.user.first_name,
                last_name: invitation.user.last_name,
                mobile_number: Faker::PhoneNumber.cell_phone
              }
            }
          end

          it "finds the user by #email" do
            expect(response).to be_ok
            parsed_response = parse_response response
            expect(parsed_response[:user_id]).to eq(user.id)
          end
        end
      end

      describe "with an invalid payload" do
        let(:payload) do
          {
            user: {
              email: Faker::Internet.email,
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              mobile_number: Faker::PhoneNumber.cell_phone
            }
          }
        end

        it "returns an unprocessable response" do
          expect(response).to be_unprocessable
          parsed_response = parse_response response
          expect(parsed_response).to eq(
            code: 422,
            message: {:redirect_uri=>["can't be blank"]},
            type: "unprocessable_entity"
          )
        end
      end
    end
  end
end
