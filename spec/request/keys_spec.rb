# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WellKnown::KeysController, type: :request do
  let(:path) { nil }

  describe "GET index" do
    let(:path) { '/.well-known/jwks.json' }
    before { get path }

    it { expect(response).to be_ok }
    
    describe "Parsing into a JWKS" do
      let(:payload) { JSON.parse(response.body, symbolize_names: true) }
      let(:key)     { JWT::JWK.import(JSON.parse(body, symbolize_names: true)[:keys].first) }
      
      it { expect { key }.not_to raise_error }

      describe "Decoding an access token" do
        let(:email)           { Faker::Internet.email }
        let(:token_payload)   { { email: email } }
        let(:private_key)     { Rails.application.config.jwt.keyset }
        let(:encrypted_token) { JWT.encode(token_payload, private_key.keypair, 'RS256', { kid: private_key.kid }) }

        subject do
          JWT.decode(encrypted_token, nil, true, { algorithms: ['RS256'], jwks: payload})
        end

        it { expect(subject.first['email']).to eql(email) }
      end
    end
  end
end
