module Sessions
  class BackupsController < ApplicationController
    before_action :redirect_home, unless: :resource

    def show
      
    end

    private

    def resource
      @resource ||= GlobalID::Locator.locate_signed(params[:id])
    end
    helper_method :resource
  
  end
end