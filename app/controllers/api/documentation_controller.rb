module Api
  class DocumentationController < BaseController
    skip_before_action :authorize!

    swagger_root do
      key :swagger, '2.0'
      info do
        key :version, '1.0.0'
        key :title, 'Identity API'
        key :description, 'To interact with Identity programatically'
      end
      key :host, 'identity.cathex.ninja'
      key :basePath, '/api'
      key :consumes, ['application/json']
      key :produces, ['application/json']
      security_definition :identity_auth do
        key :type, :oauth2
        key :tokenUrl, 'https://identity.cathex.ninja/oauth/token'
        key :flow, :application
        scopes do
          key 'invitations:write', 'Allow the creation of Invitations'
          key 'challenges:write', 'Allow the creation of pre-seeded challenges'
          key 'trades:write', 'Allow the creation of trades as attached to Users'
        end
      end
    end

    SWAGGERED_CLASSES = [
      Api::InvitationsController,
      Api::Otp::ChallengesController,
      Api::Users::TradesController,

      Api::InvitationSerializer,
      Api::Otp::ChallengeSerializer,
      Api::Users::TradeSerializer,
      ExceptionPresenter,
      self
    ].freeze
    
    def show
      render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
    end

  end
end