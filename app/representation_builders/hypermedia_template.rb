class HypermediaTemplate
  include Rails.application.routes.url_helpers

  def initialize
  end

  def collection(presenter_class, owner_id = nil, foreign_key = nil)
    suffix = foreign_key ? "?q[#{foreign_key}_eq]=#{owner_id}" : ''
    {
      class: presenter_class.model_name,
      type: "collection",
      href: uri(presenter_class: presenter_class, suffix: suffix),
      methods: presenter_class.collection_methods
    }
  end

  def entity(presenter_class, id)
    {
      class: presenter_class.model_name,
      type: "entity",
      href: id ? uri(presenter_class: presenter_class, id: id) : nil,
      methods: id ? presenter_class.entity_methods : []
    }
  end

  private

  def uri(presenter_class:, id: nil, suffix: nil)
    "#{root_url}api/#{presenter_class.model_name}".tap do |uri|
      uri << "/#{id}" if id
      uri << suffix if suffix
    end
  end
end
