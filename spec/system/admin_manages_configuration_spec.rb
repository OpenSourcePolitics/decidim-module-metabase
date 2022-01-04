# frozen_string_literal: true

require "spec_helper"

describe "Admin manages configuration", type: :system do
  let(:organization) { create(:organization, metabase_configuration: metabase_configuration) }

  let(:enabled) { true }
  let(:site_url) { "http://fake.site.url" }
  let(:secret_key) { "fake_secret_key" }
  let(:dashboard_ids) { [1] }
  let(:metabase_configuration) do
    {
      login: "login",
      password: "password",
      dashboard_ids: dashboard_ids
    }
  end

  before do
    allow(Decidim::Metabase::MetabaseCredentials).to receive(:metabase_site_url).and_return(site_url)
    allow(Decidim::Metabase::MetabaseCredentials).to receive(:metabase_enabled?).and_return(enabled)
    allow(Decidim::Metabase::MetabaseCredentials).to receive(:metabase_secret_key).and_return(secret_key)
    allow(Decidim::Metabase::MetabaseApiWrapper).to receive(:collections).and_return(dashboard_ids)
  end

  describe "with an administrator" do
    let!(:admin) { create(:user, :admin, :confirmed, organization: organization) }

    before do
      switch_to_host(organization.host)
      login_as admin, scope: :user
      visit decidim_admin.root_path
    end

    context "when accessing metabase dashboard" do
      before do
        stub_request(:any, /fake.site.url/).to_return(body: "Not found", status: 404)
        find("a[href='/admin/metabase/']").click
        click_link "Configuration"
      end

      it "renders the edit view" do
        expect(page).to have_content("Configuration")

        fill_in :organization_login, with: "login"
        fill_in :organization_password, with: "password"
        fill_in :organization_dashboard_ids, with: "1, 2, 3, 4"
        find("*[type=submit]").click

        expect(page).to have_admin_callout("Success")
      end
    end
  end

  describe "Unauthorized user manages configuration" do
    context "when user is not logged in" do
      before do
        switch_to_host(organization.host)
        visit decidim_metabase.root_path
      end

      it "redirects to sign_in page" do
        expect(page).to have_content("You need to sign in or sign up before continuing.")
      end
    end

    context "when user is logged but not administrator" do
      let!(:user) { create(:user, :confirmed, organization: organization) }

      before do
        switch_to_host(organization.host)
        login_as user, scope: :user
        visit decidim_metabase.root_path
      end

      it "is redirected" do
        expect(page).to have_content("You are not authorized to perform this action")
      end
    end
  end
end
