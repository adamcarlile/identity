# frozen_string_literal: true

require_dependency "#{Doorkeeper::Engine.root}/app/controllers/doorkeeper/authorizations_controller.rb"

module Doorkeeper
  class AuthorizationsController
    module AuthorizationsExtension

      private

      def authenticate_resource_owner!
        session[:oauth_client_id] = params[:client_id]
        super
      end

      def pre_auth_param_fields
        super.append(:nonce)
      end
    end

    Doorkeeper::AuthorizationsController.prepend AuthorizationsExtension
  end
end
