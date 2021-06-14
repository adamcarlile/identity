# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:path) { nil }
  let(:user) { create(:user) }


  context "user signed in" do
    before { login_as user }

    describe "GET show" do
      let(:path) { "/me" }
      before     { get path }

      it { expect(response).to be_ok }
    end
  end

  context "user not signed in" do
    describe "GET show" do
      let(:path) { "/me" }
      before     { get path }

      it { expect(response).to redirect_to("/login") }
    end
  end

end
