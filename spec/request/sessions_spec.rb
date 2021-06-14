# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  let(:path) { nil }

  context "user signed in" do
    let(:user) { create(:user) }
    before     { login_as user }

    describe "GET show" do
      let(:path) { "/login" }
      before     { get path }

      it { expect(response).to redirect_to("/") }
    end

    describe "DELETE destroy" do
      let(:path) { "/login" }
      before     { delete path }

      it { expect(response).to redirect_to("/") }
    end

    describe "GET destroy" do
      let(:path) { "/sessions/destroy" }
      before     { get path }

      it { expect(response).to redirect_to("/") }
    end

    describe "GET destroy with redirect" do
      let(:redirect_uri) { "http://example.com/path" }
      let(:path) { "/sessions/destroy?redirect_uri=#{redirect_uri}" }
      before { get path}

      it { expect(response).to redirect_to(redirect_uri) }
    end
  end
end
