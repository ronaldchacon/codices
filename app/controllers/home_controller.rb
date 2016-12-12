class HomeController < ApplicationController
  before_action :skip_authorization

  def index
    render alexandria_json_v1: data.to_json
  end

  private

  def data
    template = HypermediaTemplate.new
    presenters = [BookPresenter, AuthorPresenter, PublisherPresenter]
    array = presenters.each_with_object([]) do |presenter, tmp_array|
      tmp_array << template.collection(presenter)
    end
    { data: array }
  end
end
