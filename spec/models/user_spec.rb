# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  context "callbacks" do
    describe "before_save" do
      context 'on create' do
        let(:user) { build(:user, mobile_number: "07767 032217") }

        it "formats the mobile_number with the country code" do
          expect {
            user.save!
          }.to change { user.mobile_number }.to("+447767032217")
        end
      end
      context 'on update' do
        let(:user) { create(:user, mobile_number: "07767 032217") }

        it "formats the mobile_number with the country code" do
          expect {
            user.update!(mobile_number: "07767 032216")
          }.to change { user.mobile_number }.to("+447767032216")
        end
      end
    end
  end

  context "scopes" do
    describe "::by_mobile_or_email" do
      let(:user) { create(:user) }

      context "mobile_number" do
        it "returns the user by mobile number" do
          result = User.by_mobile_or_email(mobile_number: user.mobile_number, email: Faker::Internet.email).take

          expect(result.id).to eq(user.id)
        end

        it "formats the mobile number to international before querrying" do
          national_number = Phonelib.parse(user.mobile_number).full_national

          result = User.by_mobile_or_email(mobile_number: national_number, email: Faker::Internet.email).take

          expect(result.id).to eq(user.id)
        end
      end

      context "email" do
        it "returns the user by email" do
          result = User.by_mobile_or_email(mobile_number: Faker::PhoneNumber.cell_phone, email: user.email).take

          expect(result.id).to eq(user.id)
        end
      end
    end
  end

  describe "#revoke_invitations" do
    let(:user) { create(:user) }

    it "revokes all available invitations" do
      2.times { create(:user_invitation, user: user) }

      user.revoke_invitations

      expect(user.reload.invitations.pluck(:state)).to contain_exactly("revoked", "revoked")
    end
  end
end
