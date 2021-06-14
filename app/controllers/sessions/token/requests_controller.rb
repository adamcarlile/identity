module Sessions
  module Token
    class RequestsController < SessionsController

      def create
        SingleAccessTokens::CreateService.run!(user: resource, intent: :login) do |on|
          on.success do |service, token|
            User::SingleAccessTokenMailer.with(token: token).login_email.deliver_now
            flash[:notice] = "We've sent you an email with a link to log in"
            redirect_back fallback_location: sessions_backup_path(resource.to_sgid(expires_in: 10.minutes))
          end
          on.failure do |svc, message|
            flash[:alert] = message
            redirect_back fallback_location: sessions_backup_path(resource.to_sgid(expires_in: 10.minutes))
          end
        end
      end

      def resource
        @resource ||= GlobalID::Locator.locate_signed(params[:id])
      end
      helper_method :resource

    end
  end
end