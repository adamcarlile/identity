# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action -> { Thread.current[:host] = request.base_url }
  before_action :prepend_template_paths!

  protected

  def current_user
    warden.user
  end

  def redirect_home
    redirect_to root_path
  end

  def jwt_issuer
    Thread.current[:host]
  end

  def prepend_template_paths!
    prepend_view_path(oauth_application.template.path) if oauth_application.present? && oauth_application.template.present?
  end

  def oauth_application
    @oauth_application ||= Doorkeeper::Application.find_by_uid(session[:oauth_client_id]) if session[:oauth_client_id].present?
  end
  helper_method :oauth_application

end
