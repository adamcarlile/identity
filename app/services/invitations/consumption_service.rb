module Invitations
  class ConsumptionService < ServiceObject
  
    def initialize(invitation:, form:)
      @invitation, @form = invitation, form
    end

    def call
      fire(:failure, I18n.t('errors.form.invalid')) and return unless @form.valid?

      @invitation.user.update!(@form.attributes)
      Otp::DispatchService.run!(resource: @invitation.user)
      @invitation.consume!
      fire :success, @invitation
    rescue ActiveRecord::RecordNotUnique
      fire :failure, I18n.t('errors.registrations.duplicate_entry')
    rescue => e
      fire :failure, I18n.t('errors.general')
    end
  
  end
end
