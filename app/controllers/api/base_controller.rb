module Api
  class BaseController < ActionController::API
    include Swagger::Blocks
    class_attribute :permitted_scopes, default: []
    before_action :authorize!

    class << self
      def permit(*scopes)
        self.permitted_scopes += scopes
      end
    end

    protected

    def authorize!
      doorkeeper_authorize!(*permitted_scopes)
    end

    def application
      @application ||= doorkeeper_token.application
    end
  end
end
