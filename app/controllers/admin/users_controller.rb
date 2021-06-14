module Admin
  class UsersController < ResourceController

    protected

    def resource_path
      admin_user_path(resource)
    end
    helper_method :resource_path

    def collection_path
      admin_users_path
    end
    helper_method :collection_path

    def permitted_params
      params.require(:user).permit(:admin)
    end

    def collection
      @collection ||= params[:query].present? ? User.search(params[:query]) : User.ordered
    end
    helper_method :collection

    def resource
      @resource ||= params[:id] ? User.find(params[:id]) : User.new
    end
    helper_method :resource

  end
end