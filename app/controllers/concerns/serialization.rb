module Serialization
  extend ActiveSupport::Concern

  ACCEPTED_MEDIA_TYPES = {
    "*/*" => :codices_json_v1,
    "application/*" => :codices_json_v1,
    "application/vnd.codices.v1+json" => :codices_json_v1,
  }.freeze

  included do
    before_action :acceptable?
  end

  def serialize(data, options = {})
    { renderer => send(renderer, data, options) }
  end

  def acceptable?
    unacceptable! unless accepted_media_type
  end

  private

  def codices_json_v1(data, options)
    Codices::V1::Serializer.new(data: data,
                                params: params,
                                actions: [:fields, :embeds, :hypermedia],
                                options: options).to_json
  end

  def renderer
    @render ||= ACCEPTED_MEDIA_TYPES[accepted_media_type]
  end

  def accepted_media_type
    @accepted_media_type ||= find_acceptable
  end

  def find_acceptable
    accept_header = request.headers["HTTP_ACCEPT"]
    accept = Rack::Accept::MediaType.new(accept_header).qvalues
    accept.each do |media_type, _q|
      return media_type if ACCEPTED_MEDIA_TYPES[media_type]
    end
    nil
  end

  def unacceptable!
    accept = request.headers["HTTP_ACCEPT"]
    render status: 406, codices_json_v1: {
      message: "No acceptable media type in Accept header: #{accept}",
      acceptable_media_types: ACCEPTED_MEDIA_TYPES.keys,
    }.to_json
  end
end
