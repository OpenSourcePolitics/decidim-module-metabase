# frozen_string_literal: true

require "decidim/metabase/admin"
require "decidim/metabase/engine"
require "decidim/metabase/admin_engine"

module Decidim
  module Metabase
    autoload :MetabaseApiWrapper, "decidim/metabase/metabase_api_wrapper"
    autoload :MetabaseCredentials, "decidim/metabase/metabase_credentials"
  end
end
