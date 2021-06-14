class InvitationsController < ApplicationController
  before_action -> { redirect_to(root_path) }, if: :logged_in?

  def show
    consume_invitation! unless resource.confirm_details?
  end

  def edit
    
  end

  def update
    consume_invitation!
  end

  private

  def form_params
    permitted_params rescue resource.user.attributes
  end

  def permitted_params
    params.require(:invitations_confirmation_form).permit(:first_name, :last_name, :mobile_number, :email, :postcode)
  end

  def form
    @form ||= Invitations::ConfirmationForm.new(form_params)
  end
  helper_method :form

  def resource
    @resource ||= User::Invitation.available.find_by!(token: params[:id])
  end
  helper_method :resource

  def consume_invitation!
    Invitations::ConsumptionService.run!(invitation: resource, form: form) do |on|
      on.success do |service, invitation|
        session[:redirect_to]   = invitation.redirect_uri
        redirect_to new_sessions_otp_responses_path(id: invitation.user.to_sgid(expires_in: 10.minutes))
      end
      on.failure do |service, message|
        flash.now[:alert] = message
        render :show, status: :unprocessable_entity
      end
    end
  end

end