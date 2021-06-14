module WellKnown
  class DiscoveriesController < ApplicationController
    respond_to :json

    def show
      respond_with(resource)
    end

    private

    def doorkeeper
      ::Doorkeeper.configuration
    end

    def jwt
      Rails.application.config.jwt
    end

    def resource
      {
        issuer: jwt_issuer,
        authorization_endpoint: oauth_authorization_url,
        token_endpoint: oauth_token_url,
        revocation_endpoint: oauth_revoke_url,
        introspection_endpoint: oauth_introspect_url,
        jwks_uri: well_known_keys_url(format: :json),
        userinfo_endpoint: well_known_users_url(format: :json),
        # end_session_endpoint: openid_connect.end_session_endpoint.call,

        scopes_supported: doorkeeper.scopes_by_grant_type[:authorization_code],

        # TODO: support id_token response type
        response_types_supported: doorkeeper.authorization_response_types,
        response_modes_supported: [ 'query', 'fragment' ],

        token_endpoint_auth_methods_supported: [
          'client_secret_basic',
          'client_secret_post',
        ],

        subject_types_supported: ['public'],

        id_token_signing_alg_values_supported: [
          jwt.encryption_method
        ],

        claim_types_supported: [
          'normal',
        ],

        claims_supported: [
          'iss',
          'sub',
          'aud',
          'exp',
          'iat',
        ],
      }.compact
    end

  end
end