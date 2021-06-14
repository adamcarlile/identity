# frozen_string_literal: true

class SessionsController < ApplicationController
  
  def show
    redirect_to root_path and return if logged_in? 
    redirect_to new_sessions_otp_challenges_path
  end

  def create
    if form.valid? && authenticate
      current_user.activate! if current_user.can_activate?
      session.delete(:oauth_client_id)
      redirect_to(session.delete(:redirect_to) || root_path)
    else
      flash.now[:alert] = warden.message || I18n.t('errors.general')
      render(action: :new, status: :unprocessable_entity)
    end
  end

  def destroy
    logout
    
    flash[:notice] = "Successfully logged out" unless params[:redirect_uri]
    redirect       = (params[:redirect_uri] || root_path)

    redirect_to redirect
  end

  protected

  def resource
  end

end
