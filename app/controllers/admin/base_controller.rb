module Admin
  class BaseController < ActionController::Base
    include Pagy::Backend
    layout 'admin/layouts/application'

    before_action :authorize!

    protected

    def authorize!
      return true if Rails.env.development?
      head :forbidden unless logged_in? && current_user.admin?
    end

    def current_user
      warden.user
    end

  end
end