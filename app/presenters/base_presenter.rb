class BasePresenter
  include Rails.application.routes.url_helpers

  @relations = []
  @sort_attributes = []
  @filter_attributes = []
  @build_attributes = []

  class << self
    attr_accessor :relations, :sort_attributes, :filter_attributes,
                  :build_attributes

    def build_with(*args)
      @build_attributes = args.map(&:to_s)
    end

    def related_to(*args)
      @relations = args.map(&:to_s)
    end

    def sort_by(*args)
      @sort_attributes = args.map(&:to_s)
    end

    def filter_by(*args)
      @filter_attributes = args.map(&:to_s)
    end

    def cached
      @cached = true
    end

    def cached?
      @cached
    end
  end

  attr_accessor :object, :params, :data

  def initialize(object, params, options = {})
    @object = object
    @params = params
    @options = options
    @data = HashWithIndifferentAccess.new
  end

  def as_json(*)
    @data
  end

  def build(actions)
    actions.each { |action| send(action) }
    self
  end

  def fields
    FieldPicker.new(self).pick
  end

  def embeds
    EmbedPicker.new(self).embed
  end

  def validated_fields
    @fields_params ||= field_picker.fields.sort.join(",")
  end

  def validated_embeds
    @embed_params ||= embed_picker.embeds.sort.join(",")
  end

  private

  def field_picker
    @field_picker ||= FieldPicker.new(self)
  end

  def embed_picker
    @embed_picker ||= EmbedPicker.new(self)
  end
end
