class ApplicationController < ActionController::API
  rescue_from QueryBuilderError, with: :builder_error
  rescue_from RepresentationBuilderError, with: :builder_error
  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found

  protected

  def builder_error(error)
    render status: 400, json: {
      error: {
        type: error.class,
        message: error.message,
        invalid_params: error.invalid_params,
      },
    }
  end

  def orchestrate_query(scope, actions = :all)
    QueryOrchestrator.new(scope: scope,
                          params: params,
                          request: request,
                          response: response,
                          actions: actions).run
  end

  def serialize(data)
    {
      json: Codices::Serializer.new(data: data,
                                    params: params,
                                    actions: [:fields, :embeds]).to_json
    }
  end

  def resource_not_found
    render(status: 404)
  end
end
