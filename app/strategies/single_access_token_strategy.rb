class SingleAccessTokenStrategy < Warden::Strategies::Base

  def valid?
    token_present?
  end

  def authenticate!
    fail!(I18n.t('errors.access_tokens.used_token')) unless token
    if token.consume!
      database_user.verify!(:email)
      success! database_user
    else
      fail!(I18n.t('errors.general'))
    end
  end

  private

  def token_present?
    params[:token].present?
  end

  def token
    @token ||= User::SingleAccessToken.available.for(:login).find_by(token: params[:token])
  end

  def database_user
    @database_user ||= token.user
  end

end