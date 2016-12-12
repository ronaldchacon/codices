module Codices
  module V1
    class DefaultParser
      def initialize(request)
        @request = request
      end

      def parse(params)
        body = @request.body.read
        params = params.merge(JSON.parse(body)).to_unsafe_hash unless body.blank?
        ActionController::Parameters.new(params)
      end
    end
  end
end
