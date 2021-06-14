module Admin
  class ApplicationsController < ResourceController

    protected

    def resource_path
      admin_application_path(resource)
    end
    helper_method :resource_path

    def collection_path
      admin_applications_path
    end
    helper_method :collection_path

    def permitted_params
      params.require(:doorkeeper_application).permit(:name, :redirect_uri, :confidential, :template_name, scopes: [])
    end

    def collection
      @collection ||= Doorkeeper::Application.ordered
    end
    helper_method :collection

    def resource
      @resource ||= params[:id] ? Doorkeeper::Application.find(params[:id]) : Doorkeeper::Application.new
    end
    helper_method :resource

  end
end