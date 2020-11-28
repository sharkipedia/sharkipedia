module API::V1
  class BoundariesController < APIController
    Boundary = Struct.new(:id, :name) {}
    BOUNDARIES = [Boundary.new(1, "Ocean")]

    def index
      render jsonapi: BOUNDARIES
    end

    def show
      case params[:name]
      when /Oceans?/i
        render jsonapi: Ocean.all
      end
    end

    private

    def jsonapi_serializer_class(resource, is_collection)
      JSONAPI::Rails.serializer_class(resource, is_collection)
    rescue NameError
      BoundariesSerializer
    end
  end
end
