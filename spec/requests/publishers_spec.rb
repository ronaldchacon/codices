RSpec.describe "Publishers", type: :request do
  let(:oreilly) { create(:publisher) }
  let(:dev_media) { create(:dev_media) }
  let(:super_books) { create(:super_books) }
  let(:publishers) { [oreilly, dev_media, super_books] }

  describe "GET /api/publishers" do
    before(:each) { publishers }

    context "default behavior" do
      before(:each) { get "/api/publishers" }

      it "gets HTTP status 200" do
        expect(response.status).to eq 200
      end

      it "receives a json object with the 'data' root key" do
        expect(json_body["data"]).to_not be nil
      end

      it "receives all 3 publishers" do
        expect(json_body["data"].size).to eq 3
      end
    end

    describe "field picking" do
      context "with the fields parameter" do
        before(:each) { get "/api/publishers?fields=id,name" }

        it "gets publishers with only the id, name keys" do
          json_body["data"].each do |book|
            expect(book.keys).to eq ["id", "name"]
          end
        end
      end

      context "without the field parameter" do
        before(:each) { get "/api/publishers" }

        it "gets publishers with all fields specified in the presenter" do
          json_body["data"].each do |book|
            expect(book.keys).to eq PublisherPresenter.build_attributes.map(&:to_s)
          end
        end
      end

      context "with invalid field name 'fid'" do
        before(:each) { get "/api/publishers?fields=fid,name" }

        it "gets '400 Bad Request' back" do
          expect(response.status).to eq 400
        end

        it "receives an error" do
          expect(json_body["error"]).to_not be nil
        end

        it "receives 'fields=fid' as an invalid param" do
          expect(json_body["error"]["invalid_params"]).to eq "fields=fid"
        end
      end
    end

    describe "pagination" do
      context "when asking for the first page" do
        before(:each) { get "/api/publishers?page=1&per=2" }

        it "receives HTTP status 200" do
          expect(response.status).to eq 200
        end

        it "receives only two publishers" do
          expect(json_body["data"].size).to eq 2
        end

        it "receives a response with the Link header" do
          expect(response.headers["Link"].split(", ").first).to eq(
            '<http://www.example.com/api/publishers?page=2&per=2>; rel="next"',
          )
        end
      end

      context "when asking for the second page" do
        before(:each) { get("/api/publishers?page=2&per=2") }

        it "receives HTTP status 200" do
          expect(response.status).to eq 200
        end

        it "receives only one book" do
          expect(json_body["data"].size).to eq 1
        end
      end

      context "when sending invalid 'page' and 'per' parameters" do
        before(:each) { get("/api/publishers?page=fake&per=25") }

        it "receives HTTP status 400" do
          expect(response.status).to eq 400
        end

        it "receives an error" do
          expect(json_body["error"]).to_not be nil
        end

        it "receives 'page=fake' as an invalid param" do
          expect(json_body["error"]["invalid_params"]).to eq "page=fake"
        end
      end
    end

    describe "sorting" do
      context "with valid column name 'id'" do
        it "sorts the publishers by id desc" do
          get("/api/publishers?sort=id&dir=desc")
          expect(json_body["data"].first["id"]).to eq super_books.id
          expect(json_body["data"].last["id"]).to eq oreilly.id
        end
      end

      context "with invalid column name 'fid'" do
        before(:each) { get "/api/publishers?sort=fid&dir=asc" }

        it "gets '400 Bad Request' back" do
          expect(response.status).to eq 400
        end

        it "receives an error" do
          expect(json_body["error"]).to_not be nil
        end

        it "receives 'sort=fid' as an invalid param" do
          expect(json_body["error"]["invalid_params"]).to eq "sort=fid"
        end
      end
    end

    describe "filtering" do
      context 'with valid filtering param "q[name_cont]=Reilly"' do
        it "receives O'reilly back" do
          get("/api/publishers?q[name_cont]=Reilly")
          expect(json_body["data"].first["id"]).to eq oreilly.id
          expect(json_body["data"].size).to eq 1
        end
      end

      context 'with invalid filtering param "q[fname_cont]=Reilly"' do
        before { get("/api/publishers?q[fgiven_name_cont]=Reilly") }
        it "gets '400 Bad Request' back" do
          expect(response.status).to eq 400
        end

        it "receives an error" do
          expect(json_body["error"]).to_not be nil
        end

        it "receives 'q[fgiven_name_cont]=Reilly' as an invalid param" do
          expect(json_body["error"]["invalid_params"]).to eq "q[fgiven_name_cont]=Reilly"
        end
      end
    end
  end

  describe "GET /api/publishers/:id" do
    context "with existing resource" do
      before(:each) { get "/api/publishers/#{oreilly.id}" }

      it "gets HTTP status 200" do
        expect(response.status).to eq 200
      end

      it "receives 'oreilly' as JSON" do
        expected = { data: PublisherPresenter.new(oreilly, {}).fields.embeds }
        expect(response.body).to eq expected.to_json
      end
    end

    context "with nonexistent resource" do
      it "receives HTTP status 404" do
        get "/api/publishers/123454321"
        expect(response.status).to eq 404
      end
    end
  end

  describe "POST /api/publishers" do
    before(:each) { post "/api/publishers", params: { data: params } }

    context "with valid parameters" do
      let(:params) do
        attributes_for(:publisher)
      end

      it "gets HTTP status 201" do
        expect(response.status).to eq 201
      end

      it "receives the newly created resource" do
        expect(json_body["data"]["name"]).to eq "O'Reilly"
      end

      it "adds a record in the database" do
        expect(Publisher.count).to eq 1
      end

      it "gets the new resource location in the Location header" do
        expect(response.headers["Location"]).to eq("http://www.example.com/api/publishers/#{Publisher.first.id}")
      end
    end

    context "with invalid parameters" do
      let(:params) do
        attributes_for(:publisher, name: "")
      end

      it "gets HTTP status 422" do
        expect(response.status).to eq 422
      end

      it "receives an error details" do
        expect(json_body["error"]["invalid_params"]).to eq("name" => ["can't be blank"])
      end

      it "does not add a record in the database" do
        expect(Publisher.count).to eq 0
      end
    end
  end

  describe "PATCH /api/publishers/:id" do
    before { patch "/api/publishers/#{oreilly.id}", params: { data: params } }

    context "with valid parameters" do
      let(:params) { { name: "New Riders" } }

      it "gets HTTP status 200" do
        expect(response.status).to eq 200
      end

      it "receives the updated resource" do
        expect(json_body["data"]["name"]).to eq("New Riders")
      end

      it "updates the record in the database" do
        expect(Publisher.first.name).to eq "New Riders"
      end
    end

    context "with invalid parameters" do
      let(:params) { { name: "" } }

      it "gets HTTP status 422" do
        expect(response.status).to eq 422
      end

      it "receives an error details" do
        expect(json_body["error"]["invalid_params"]).to eq("name" => ["can't be blank"])
      end

      it "does not add a record in the database" do
        expect(Publisher.first.name).to eq "O'Reilly"
      end
    end
  end

  describe "DELETE /api/publishers/:id" do
    context "with existing resource" do
      before { delete "/api/publishers/#{oreilly.id}" }

      it "gets HTTP status 204" do
        expect(response.status).to eq 204
      end

      it "deletes the book from the database" do
        expect(Publisher.count).to eq 0
      end
    end

    context "with nonexistent resource" do
      it "gets HTTP status 404" do
        delete "/api/publishers/123454321"
        expect(response.status).to eq 404
      end
    end
  end
end
