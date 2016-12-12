RSpec.describe 'Serialization', type: :request do
  let(:api_key) { ApiKey.create }
  let(:headers) do
    {
      "HTTP_AUTHORIZATION" => "Codices-Token api_key=#{api_key.id}:#{api_key.key}",
      "HTTP_ACCEPT" => accept
    }
  end

  let(:valid_media_type) { "application/vnd.codices.v1+json; charset=utf-8" }
  context "with 'Accept: application/xml, */*'" do
    let(:accept) { "application/xml, */*" }
    it "returns 200 OK" do
      get "/api/books", headers: headers
      expect(response.status).to eq 200
    end

    it "returns 'application/vnd.codices.v1+json'" do
      get "/api/books", headers: headers
      expect(response.headers["Content-Type"]).to eq valid_media_type
    end
  end

  context "with 'Accept: application/vnd.codices.v1+json'" do
    let(:accept) { "application/vnd.codices.v1+json" }
    it "returns 200 OK" do
      get "/api/books", headers: headers
      expect(response.status).to eq 200
    end

    it "returns 'application/vnd.codices.v1+json'" do
      get "/api/books", headers: headers
      expect(response.headers["Content-Type"]).to eq valid_media_type
    end

    it "returns valid JSON" do
      get "/api/books", headers: headers
      expect { JSON.parse(response.body) }.to_not raise_exception
    end
  end

  context "with 'Accept: application/json'" do
    let(:accept) { "application/json" }
    it "returns 406 Unacceptable" do
      get "/api/books", headers: headers
      expect(response.status).to eq 406
    end

    it "returns 'application/vnd.codices.v1+json'" do
      get "/api/books", headers: headers
      expect(response.headers["Content-Type"]).to eq valid_media_type
    end
  end
end
