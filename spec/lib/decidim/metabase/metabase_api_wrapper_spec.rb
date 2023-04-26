# frozen_string_literal: true

require "spec_helper"

describe Decidim::Metabase::MetabaseApiWrapper do
  subject { described_class }

  let(:site_url) { "https://fake_site_url" }
  let(:path) { "" }
  let(:params) do
    {}
  end
  let(:method) { :get }
  let(:headers) do
    {}
  end
  let(:response_headers) do
    {}
  end
  let(:response_body) { "" }
  let(:response_code) { 200 }
  let(:default_headers) do
    {
      "Accept" => "*/*",
      "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
      "Host" => "fake_site_url",
      "User-Agent" => "Ruby"
    }
  end

  before do
    allow(Decidim::Metabase::MetabaseCredentials).to receive(:metabase_site_url).and_return(site_url)
    stub_request(method, "https://fake_site_url#{path}").with(body: params.empty? ? params : JSON.dump(params),
                                                              headers: default_headers.merge(headers))
                                                        .to_return(status: response_code, body: response_body, headers: response_headers)
  end

  describe ".request_path" do
    let(:expected_path) { "#{site_url}/dummy_path" }

    it "returns a path" do
      expect(subject.request_path("/dummy_path")).to eq(URI(expected_path))
    end
  end

  describe ".call" do
    it "sends a get request" do
      expect(subject.call(path, params, method, headers).code).to eq("200")
    end

    context "when method is post" do
      let(:method) { :post }

      it "sends a post request" do
        expect(subject.call(path, params, method, headers).code).to eq("200")
      end
    end

    context "when header are provided" do
      let(:headers) do
        { "Dummy" => "header",
          "Another_dummy" => "header" }
      end

      it "adds them to the request" do
        expect(subject.call(path, params, method, headers).code).to eq("200")
      end
    end

    context "when params are provided" do
      let(:params) do
        {
          dummy: "params",
          another_dummy: "params"
        }
      end

      it "adds them to the request" do
        expect(subject.call(path, params, method, headers).code).to eq("200")
      end
    end
  end

  describe ".auth_token" do
    let(:method) { :post }
    let(:path) { "/api/session" }
    let(:params) do
      { username: "login", password: "password" }
    end
    let(:headers) do
      {
        "Content-Type" => "application/json"
      }
    end
    let(:response_body) do
      JSON.dump({ "id": "dummy_id" })
    end

    it "parse the response" do
      expect(subject.auth_token(params)).to eq("dummy_id")
    end

    context "when response is not 200" do
      let(:response_code) { "401" }

      it "raises an error" do
        expect { subject.auth_token(params) }.to raise_error(RuntimeError, "auth_token request error with error code 4")
      end
    end
  end

  describe ".collections" do
    let(:path) { "/api/collection" }
    let(:headers) do
      {
        "X-Metabase-Session" => "dummy_token"
      }
    end
    let(:response_body) do
      JSON.dump([
                  { id: 1 },
                  { id: 2 },
                  { id: 3 },
                  { id: 4 }
                ])
    end

    before do
      allow(Decidim::Metabase::MetabaseApiWrapper).to receive(:metabase_auth_token).with("login", "password").and_return("dummy_token")
    end

    it "parse the response" do
      expect(subject.collections("login", "password")).to eq([1, 2, 3, 4])
    end

    context "when response is not 200" do
      let(:response_code) { "401" }

      it "raises an error" do
        expect { subject.collections("login", "password") }.to raise_error(RuntimeError, "collections request error with error code 4")
      end
    end
  end

  describe ".metabase_auth_token" do
    before do
      allow(Decidim::Metabase::MetabaseApiWrapper).to receive(:auth_token).with({ password: "password", username: "login" }).and_return(nil)
    end

    it "calls auth_token method" do
      subject.metabase_auth_token("login", "password")

      expect(Decidim::Metabase::MetabaseApiWrapper).to have_received(:auth_token).with({ password: "password", username: "login" })
    end
  end
end
