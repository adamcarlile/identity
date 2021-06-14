class RegistrationsController < ApplicationController
  before_action :redirect_home, if: :logged_in?
  
  def new
    @form = RegistrationForm.new
  end

  def create
    Registrations::CreateService.run!(form: form) do |on|
      on.success do |service, user|
        redirect_to new_sessions_otp_responses_path(id: user.to_sgid(expires_in: 10.minutes))
      end
      on.failure do |service, message|
        flash.now[:alert] = message
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def permitted_params
    params.require(:registration_form).permit(:first_name, :last_name, :mobile_number, :email, :postcode)
  end

  def form
    @form ||= RegistrationForm.new(permitted_params)
  end
  helper_method :form

end
