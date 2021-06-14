# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationsController, type: :request do
  let(:path) { nil }

  context "GET new" do
    let(:path)  { "/registrations/new" }
    before      { get path }

    it { expect(response).to be_ok }
  end

  context "POST create" do
    let(:path)          { "/registrations" }
    let(:first_name)    { Faker::Name.first_name }
    let(:last_name)     { Faker::Name.last_name }
    let(:mobile_number) { "+447590673597" }
    let(:email)         { Faker::Internet.email name: [first_name, last_name].join(' ') }
    let(:postcode)      { Faker::Address.postcode }
    let(:payload)       { { 
      registration_form: { 
        first_name: first_name, 
        last_name: last_name, 
        mobile_number: mobile_number, 
        email: email, 
        postcode: postcode }
      } 
    }

    before { post path, params: payload }

    it { expect(response).to be_redirect }
    it { expect(User.find_by(email: email).persisted?).to be_truthy }

    context "with invalid parameters" do
      let(:mobile_number) { "Hello" }

      it { expect(response).to be_unprocessable }
    end
  end

  context "user signed in" do
    let(:user) { create(:user) }
    before     { login_as user }

    describe "GET new" do
      let(:path) { "/registrations/new" }
      before     { get path }

      it { expect(response).to be_redirect }
    end

    describe "POST create" do
      let(:path) { "/registrations" }
      before     { post path }

      it { expect(response).to be_redirect }
    end
  end
end
