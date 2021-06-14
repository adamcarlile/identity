class OneTimePasswordStrategy < Warden::Strategies::Base

  def valid?
    mobile_number.present? && otp.present? && database_user.present?
  end

  def authenticate!
    fail!(I18n.t('errors.otp.expired_token')) unless database_user.otp_current?
    if database_user.authenticate_otp(otp, auto_increment: true)
      database_user.verify!(:mobile_number)
      success! database_user
    else
      fail!(I18n.t('errors.otp.incorrect_token'))
    end
  end

  private

  def form
    @form ||= Sessions::Otp::ResponseForm.new(credentials)
  end

  def mobile_number
    form.mobile_number
  end

  def otp
    form.one_time_password
  end

  def credentials
    params[:credentials] || {}
  end

  def database_user
    @database_user ||= User.find_by mobile_number: mobile_number
  end

end
