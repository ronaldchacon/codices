module RequestParsing
  extend ActiveSupport::Concern

  SUPPORTED_MEDIA_TYPES = {
    "application/vnd.codices.v1+json" => Codices::V1::DefaultParser,
  }

  included do
    rescue_from JSON::ParserError, with: :bad_request
    before_action :supported_media_type?, only: [:create, :update]
  end

  def params
    @params ||= @parse_body ? parser.parse(super) : super
  end

  def supported_media_type?
    unless SUPPORTED_MEDIA_TYPES.keys.include?(content_type)
      unsupported_media_type!
    end
    @parse_body = true
  end

  private

  def parser
    @parser ||= SUPPORTED_MEDIA_TYPES[content_type].new(request)
  end

  def content_type
    @content_type ||= request.headers["Content-Type"]
  end

  def bad_request
    render status: :bad_request, codices_json_v1: {
      message: "Malformed Codices JSON document.",
    }
  end

  def unsupported_media_type!
    render status: :unsupported_media_type, codices_json_v1: {
      message: "Unsupported Media Type in Content-Type header: #{content_type}",
      supported_media_types: SUPPORTED_MEDIA_TYPES.keys,
    }
  end
end
