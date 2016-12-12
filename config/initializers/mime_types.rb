Mime::Type.register "application/vnd.codices.v1+json", :codices_json_v1

ActionController::Renderers.add :codices_json_v1 do |obj, options|
  self.content_type = Mime::Type.lookup("application/vnd.codices.v1+json")
  self.response_body = obj
end
