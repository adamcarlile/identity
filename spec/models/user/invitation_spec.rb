# frozen_string_literal: true

require "rails_helper"

RSpec.describe User::Invitation, type: :model do
  describe 'callbacks' do
    describe 'before_create' do
      before do
        @invitation = create(:user_invitation)
        @user = @invitation.user
        @new_invitation = build(:user_invitation, user: @user)
      end

      it "does revoke existing available invitations of user" do
        @new_invitation.save!

        expect(@user.invitations.reload.first.revoked?).to eq(true)
        expect(@user.invitations.last.available?).to eq(true)
      end
    end
  end
end
