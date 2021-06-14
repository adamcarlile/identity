# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExceptionsController, type: :request do

  context "404" do
    let(:path)  { "/404" }
    before      { get path }

    it { expect(response).to be_not_found }
  end

end
