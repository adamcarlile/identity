module Api
  module Otp
    class ChallengesController < BaseController
      permit 'challenges:write'

      swagger_path '/otp/challenges' do
        operation :post do
          security do
            key :identity_auth, ['challenges:write']
          end
          key :summary, 'Create an OTP response link from the phone number'
          key :description, 'Returns a URL that contains a securely encoded parameter that can be used to load the user for the response, will sent an OTP request'
          parameter do
            key :name, :user
            key :in, :body
            key :description, 'User payload'
            key :required, true
            schema do
              property :mobile_number do
                key :type, :string
              end
            end
          end
          response 200 do
            key :description, 'OTP Response prompt'
            schema do
              key :'$ref', :OtpChallenge
            end
          end
          response :default do
            key :description, 'unexpected error'
            schema do
              key :'$ref', :Error
            end
          end
        end
      end

      def create
        ::Otp::Challenges::CreateService.run!(form: form) do |on|
          on.success do |service, user|
            render json: Api::Otp::ChallengeSerializer.new(user, self).as_json
          end
          on.failure do |service, error|
            render json: error, status: error[:code]
          end
        end
      end

      private

      def permitted_params
        params.require(:user).permit(:mobile_number)
      end

      def form
        @form ||= Sessions::Otp::ChallengeForm.new(permitted_params)
      end

    end
  end
end
