module WellKnown
  class WebfingersController < ApplicationController
    WEBFINGER_RELATION = 'http://openid.net/specs/connect/1.0/issuer'
    
    respond_to :json

    def show
      respond_with(resource)
    end

    private

    def resource
      {
        subject: params.require(:resource),
        links: [
          {
            rel: WEBFINGER_RELATION,
            href: root_url,
          }
        ]
      }
    end

  
  end
end