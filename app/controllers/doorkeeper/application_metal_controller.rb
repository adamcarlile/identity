require_dependency "#{Doorkeeper::Engine.root}/app/controllers/doorkeeper/application_metal_controller.rb"

module Doorkeeper
  class ApplicationMetalController
    before_action -> { Thread.current[:host] = request.base_url }
  end
end