module WellKnown
  class UsersController < ApplicationController
    before_action -> { doorkeeper_authorize! :openid }

    respond_to :json

    def show
      respond_with(resource)
    end

    private

    def resource
      @resouce ||= Identity::ClaimsBuilder.call(application: doorkeeper_token.application,
                                                resource: user, 
                                                scopes: doorkeeper_token.scopes,
                                                expires_in: doorkeeper_token.expires_in_seconds,
                                                created_at: doorkeeper_token.created_at.to_i,
                                                issuer: jwt_issuer)
    end

    def user
      @user ||= UserClaimsPresenter.new(User.find(doorkeeper_token.resource_owner_id))
    end

  end
end
