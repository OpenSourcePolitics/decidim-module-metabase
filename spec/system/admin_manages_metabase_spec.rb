# frozen_string_literal: true

require "spec_helper"

describe "Admin manages Metabase", type: :system do
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

  describe "with an adminstrator" do
    let!(:admin) { create(:user, :admin, :confirmed, organization: organization) }

    before do
      switch_to_host(organization.host)
      login_as admin, scope: :user
      visit decidim_admin.root_path
    end

    it "menu contains Metabase link" do
      within "nav.main-nav" do
        expect(page).to have_content("Metabase")
        expect(page).to have_selector("a[href='/admin/metabase/']")
      end
    end

    context "when accessing metabase dashboard" do
      before do
        stub_request(:any, /fake.site.url/).to_return(body: "Not found", status: 404)
        find("a[href='/admin/metabase/']").click
      end

      it "renders the index view" do
        within ".card#metabase" do
          expect(page).to have_content("Metabase dashboards")
          expect(page).to have_selector("iframe[data-dashboard='0']")
        end
      end

      context "when there is multiple dashboards" do
        let(:dashboard_ids) { [1, 2, 3] }

        it "renders the index view" do
          within ".card#metabase" do
            expect(page).to have_selector("iframe[data-dashboard='0']")
            expect(page).to have_selector("iframe[data-dashboard='1']")
            expect(page).to have_selector("iframe[data-dashboard='2']")
          end
        end
      end

      context "when there is no dashboards" do
        let(:dashboard_ids) { [] }

        it "display not found message" do
          within ".card#metabase" do
            expect(page).to have_content("No dashboard found")
          end
        end
      end

      context "when metabase is disabled" do
        let(:enabled) { false }

        it "displays disabled module message" do
          within ".card#metabase" do
            expect(page).to have_content("Metabase module seems to be disabled")
          end
        end
      end
    end
  end

  describe "Unauthorized user manages dashboards" do
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
        expect(page).not_to have_content("Metabase#Index")
        expect(page).to have_content("You are not authorized to perform this action")
      end
    end
  end
end
