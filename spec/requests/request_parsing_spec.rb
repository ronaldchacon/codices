RSpec.describe "Request Parsing", type: :request do
  let(:john) { create(:admin) }
  let(:api_key) { ApiKey.create }
  let(:api_key_str) { "#{api_key.id}:#{api_key.key}" }
  let(:access_token) { AccessToken.create(user: john, api_key: api_key) }
  let(:token_str) { "#{john.id}:#{access_token.generate_token}" }

  let(:headers) do
    {
      "HTTP_AUTHORIZATION" => "Codices-Token api_key=#{api_key_str},
      access_token=#{token_str}",
      "CONTENT_TYPE" => content_type,
    }
  end

  let(:author) { create(:michael_hartl) }
  let(:params) do
    {
      data: attributes_for(:ruby_on_rails_tutorial,
                           author_id: author.id),
    }.to_json
  end

  before { post "/api/books", headers: headers, params: params }

  context "with 'Content-Type: application/vnd.codices.v1+json'" do
    let(:content_type) { "application/vnd.codices.v1+json" }
    context "with valid JSON" do
      it "returns 201 Created" do
        expect(response.status).to eq 201
      end
    end

    context "with invalid JSON" do
      let(:params) { "{ 'data': { title: 'Rails Tutorial'" }
      it "returns 400 Bad Request" do
        expect(response.status).to eq 400
      end
    end
  end

  context "with 'Content-Type: application/json'" do
    let(:content_type) { "application/json" }
    it "returns 415 Unsupported Media Type" do
      expect(response.status).to eq 415
    end

    it "returns 'application/vnd.codices.v1+json'" do
      expect(response.headers["Content-Type"]).
        to eq("application/vnd.codices.v1+json; charset=utf-8")
    end
  end
end
