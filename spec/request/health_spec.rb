# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /health/database', type: :request do
  context 'when database is up and running' do
    it 'succeeds' do
      get '/health/database'
      expect(response.status).to be(200)
    end
  end

  context 'when database connection drops' do
    it 'responds with errors' do
      ActiveRecord::Base.remove_connection
      get '/health/database'
      expect(response.status).to be(500)
      ActiveRecord::Base.establish_connection
    end
  end
end
