# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitationsController, type: :request do
  let(:path) { nil }
  let!(:invitation) { create :user_invitation, confirm_details: false }

  context "GET show" do
    let(:path)  { "/invitations/#{invitation.token}" }
    before      { get path }

    it { expect(response).to be_redirect }
    it { expect(session[:redirect_to]).to eql(invitation.redirect_uri)}
    it { expect(invitation.reload.consumed?).to be_truthy }
  end

end
