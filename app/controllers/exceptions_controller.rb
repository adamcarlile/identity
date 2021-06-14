class ExceptionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :track_exception!
  respond_to :html, :json

  def unauthenticated
    session[:redirect_to] = request.original_url unless (warden && warden.message.present?)
    flash.alert = warden.message if (warden && warden.message.present?)
    respond_with(error, status: error.status_code) do |format|
      format.html { redirect_to sessions_path }
    end
  end

  def show
    respond_with error, status: error.status_code
  end

  protected

  private

  def error
    ExceptionPresenter.new(request, action_dispatch_error || warden_failure || fallback_error)
  end
  helper_method :error

  def action_dispatch_error
    request.env['action_dispatch.exception']
  end

  def warden_failure?
    warden_options[:action] == "unauthenticated"
  end

  def warden_options
    request.env['warden.options'] || {}
  end

  def warden_failure
    Exceptions::Unauthenticated.new(warden_options[:message]) if warden_failure?
  end

  def fallback_error
    StandardError.new
  end

  def track_exception!
    Raven.capture_exception(error.object)
  end

end