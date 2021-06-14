module WellKnown
  class KeysController < ApplicationController
    respond_to :json

    def index
      respond_with(resource)
    end

    private

    def resource
      {
        keys: [
          key.export
        ]
      }
    end

    def key
      Rails.application.config.jwt.keyset
    end

  end
end