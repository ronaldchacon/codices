module Codices
  class CollectionSerializer
    def initialize(collection, params, actions)
      @collection = collection
      @params = params
      @actions = actions
    end

    def serialize
      return @collection unless @collection.any?
      build_data
    end

    def key
      @key ||= Digest::SHA1.hexdigest(build_key)
    end

    def cache?
      presenter_class.cached?
    end

    private

    def build_data
      @collection.map do |entity|
        presenter = presenter_class.new(entity, @params)
        EntitySerializer.new(presenter, @actions).serialize
      end
    end

    def presenter_class
      @presenter_class ||= "#{@collection.model}Presenter".constantize
    end

    def build_key
      last = @collection.unscoped.order("updated_at DESC").first
      presenter = presenter_class.new(last, @params)
      updated_at = last.try(:updated_at).try(:to_datetime)
      cache_key = "collection/#{last.class}/#{updated_at}"
      [:sort, :dir, :page, :per, :q].each do |param|
        cache_key << "/#{param}:#{@params[param]}" if @params[param]
      end

      if presenter.validated_fields.present?
        cache_key << "/fields:#{presenter.validated_fields}"
      end

      if presenter.validated_embeds.present?
        cache_key << "/embeds:#{presenter.validated_embeds}"
      end

      cache_key
    end
  end
end
