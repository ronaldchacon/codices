class HypermediaBuilder
  def initialize(presenter)
    @presenter = presenter
    @template = HypermediaTemplate.new
  end

  def build
    if @presenter.class.hypermedia?
      @presenter.data[:links] ||= {}
      add_hypermedia_for_relationships
      add_hypermedia
    end
    @presenter
  end

  private

  def add_hypermedia
    links = @template.entity(@presenter.class, @presenter.object.id)
    @presenter.data[:links][:self] = links
  end

  def add_hypermedia_for_relationships
    @presenter.class.relations.each do |relationship|
      presenter = "#{relationship.singularize.capitalize}Presenter".constantize
      association = @presenter.object.class.reflections[relationship]
      foreign_key = association.foreign_key
      @presenter.data[:links][relationship] = if association.collection?
        @template.collection(presenter, @presenter.object.id, foreign_key)
      else
        @template.entity(presenter, @presenter.object.send(foreign_key))
      end
    end
  end
end
