# frozen_string_literal: true

require "uri"
require "net/http"

class Decidim::Metabase::MetabaseApiWrapper
  def self.auth_token(credentials)
    auth_token = call("/api/session", credentials, :post)

    JSON.parse(auth_token)["id"]
  end

  def self.collections(login, password)
    collections = call("/api/collection", nil, :get, { "X-Metabase-Session": metabase_auth_token(login, password) })

    JSON.parse(collections).map { |collection| collection["id"] }
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
    response = https.request(request)
    response.read_body
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
