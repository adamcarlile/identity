module Admin
  class ResourceController < BaseController

    def show
    end

    def index
    end

    def new
    end

    def edit
    end

    def create
      if resource.update(permitted_params) && resource.valid?
        resource.save
        redirect_to collection_path, notice: "#{controller_name.humanize} created successfully"
      else
        render :new
      end
    end

    def update
      if resource.update(permitted_params) && resource.valid?
        resource.save
        redirect_to collection_path, notice: "#{controller_name.humanize} updated successfully"
      else
        render :edit
      end
    end

    def destroy
      if resource.destroy
        redirect_to collection_path, notice: "#{controller_name.humanize} deleted successfully"
      else
        render :index
      end
    end

    protected

    def resource_path
      raise NotImplemented
    end
    helper_method :resource_path

    def collection_path
      raise NotImplemented
    end
    helper_method :collection_path

    def permitted_params
      raise NotImplemented
    end

    def collection
      raise NotImplemented
    end
    helper_method :collection

    def resource
      raise NotImplemented
    end
    helper_method :resource

    def collection_page
      paginated_collection.last
    end
    helper_method :collection_page

    def pagination
      paginated_collection.first
    end
    helper_method :pagination

    private

    def paginated_collection
      @paginated_collection ||= pagy(collection)
    end

  end
end