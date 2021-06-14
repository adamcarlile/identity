require 'rails_helper'

RSpec.describe Identity::ClaimsBuilder do
  let(:user_object)     { create(:user) }
  let(:user)            { UserClaimsPresenter.new(user_object) }
  let(:application_id)  { SecureRandom.uuid }
  let(:application)     { OpenStruct.new(uid: application_id) }
  let(:expires_in)      { 2.hours.seconds.to_i }
  let(:created_at)      { Time.zone.now.utc }
  let(:issuer)          { "https://identity.example.com" }
  let(:token)           { false }
  let(:scopes)          { ["openid"] }

  let(:mappings)        { Identity::ClaimsBuilder::SCOPE_MAPPINGS }
  let(:default_keys)    { [:aud, :iss, :exp, :iat, :"cat.org"] }
  let(:expected_keys)   { (mappings.slice(*scopes.map(&:to_sym)).values.flatten + default_keys).sort }
  let(:unexpected_keys) { (mappings.values.flatten - expected_keys).sort }

  subject { Identity::ClaimsBuilder.call(application: application,
                                        resource: user,
                                        scopes: scopes,
                                        expires_in: expires_in,
                                        created_at: created_at,
                                        issuer: issuer,
                                        token: token ) }

  describe "Essential claims" do
    it { expect(subject[:aud]).to eql(application_id) }
    it { expect(subject[:iss]).to eql(issuer) }
    it { expect(subject[:exp]).to eql(expires_in.seconds.from_now.to_i) }
    it { expect(subject[:iat]).to eql(created_at.to_i) }
  end

  describe "Platform claims" do
    context "For users with no trades" do
      it { expect(subject[:'cat.org']).to be_empty }
    end

    context "For users with one trade" do
      let(:state) { "pending" }
      let!(:trade) { create(:trade, user: user_object, state: state)}

      it { expect(subject[:'cat.org']).to_not be_empty }
      it { expect(subject[:'cat.org'].first[:id]).to eql(trade.external_id) }
    end
  end

  describe "Scopes" do
    context "With just the openid scope" do
      it { expect(subject[:sub]).to eql(user.id) }
      it { expect(subject.keys.sort).to eql(expected_keys) }
      it { expect(subject.keys.sort).to_not eql(unexpected_keys) }
    end

    context "With the openid and email scope" do
      let(:scopes) { ["openid", "email"] }

      it { expect(subject[:email]).to eql(user.email) }
      it { expect(subject.keys.sort).to eql(expected_keys) }
      it { expect(subject.keys.sort).to_not eql(unexpected_keys) }
    end

    context "With the openid, email and profile scope" do
      let(:scopes) { ["openid", "email", "profile"] }

      it { expect(subject[:given_name]).to eql(user.first_name) }
      it { expect(subject.keys.sort).to eql(expected_keys) }
      it { expect(subject.keys.sort).to_not eql(unexpected_keys) }
    end

    context "With the openid, email, profile and address scope" do
      let(:scopes) { ["openid", "email", "profile", "address"] }

      it { expect(subject.keys.sort).to eql(expected_keys) }
      it { expect(subject.keys.sort).to_not eql(unexpected_keys) }
    end

    context "With the openid, email, profile, address and phone scope" do
      let(:scopes) { ["openid", "email", "profile", "address", "phone"] }

      it { expect(subject[:phone_number]).to eql(user.mobile_number) }
      it { expect(subject.keys.sort).to eql(expected_keys) }
      it { expect(subject.keys.sort).to_not eql(unexpected_keys) }
    end
  end

end
