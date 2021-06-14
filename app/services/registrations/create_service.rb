module Registrations
  class CreateService < ServiceObject

    def initialize(form:)
      @form = form
    end

    def call
      fire(:failure, I18n.t('errors.form.invalid')) and return unless @form.valid?
      Otp::DispatchService.run!(resource: user)
      fire :success, user
    rescue ActiveRecord::RecordNotUnique
      fire :failure, I18n.t('errors.registrations.duplicate_entry')
    rescue => e
      fire :failure, I18n.t('errors.general')
    end

    private

    def user
      @user ||= User.create!({
        mobile_number: @form.mobile_number,
        email: @form.email,
        first_name: @form.first_name,
        last_name: @form.last_name,
      })
    end
      
  end
end
