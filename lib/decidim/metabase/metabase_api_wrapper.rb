# frozen_string_literal: true

require "uri"
require "net/http"

class Decidim::Metabase::MetabaseApiWrapper
  def self.auth_token(credentials)
    auth_token = call("/api/session", credentials, :post)

    raise "auth_token request error with error code #{auth_token.code}" unless auth_token.code == "200"

    JSON.parse(auth_token.read_body)["id"]
  end

  def self.collections(login, password)
    collections = call("/api/collection", nil, :get, { "X-Metabase-Session": metabase_auth_token(login, password) })

    raise "collections request error with error code #{collections.code}" unless collections.code == "200"

    JSON.parse(collections.read_body).map { |collection| collection["id"] }
  end

  def self.call(path, params, method, headers = nil)
    url = request_path(path)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = method == :post ? Net::HTTP::Post.new(url) : Net::HTTP::Get.new(url)

    if headers.present?
      headers.each do |key, value|
        request[key] = value
      end
    end

    if params.present?
      request["Content-Type"] = "application/json"
      request.body = JSON.dump(params)
    end

    https.request(request)
  end

  def self.request_path(path)
    URI("#{Decidim::Metabase::MetabaseCredentials.metabase_site_url}#{path}")
  end

  def self.metabase_auth_token(login, password)
    Rails.cache.fetch("#{Digest::SHA1.hexdigest("#{login}/#{password}")}/auth_token", expires_in: 7.days) do
      Decidim::Metabase::MetabaseApiWrapper.auth_token({
                                                         username: login,
                                                         password: password
                                                       })
    end
  end
end
