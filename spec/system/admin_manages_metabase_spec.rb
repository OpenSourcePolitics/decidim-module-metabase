# frozen_string_literal: true

require "spec_helper"

describe "Admin manages Metabase", type: :system do
  let(:organization) { create(:organization) }

  let(:enabled) { true }
  let(:metabase_site_url) { "http://fake.site.url" }
  let(:metabase_secret_key) { "fake_secret_key" }
  let(:metabase_dashboard_ids) { [1] }
  let(:metabase_secrets) do
    {
      enabled: enabled,
      site_url: metabase_site_url,
      secret_key: metabase_secret_key,
      dashboard_ids: metabase_dashboard_ids
    }
  end

  before do
    allow(Rails.application.secrets).to receive(:metabase).and_return(metabase_secrets)
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
          expect(page).to have_selector("iframe")
        end
      end

      context "when there is multiple dashboards" do
        let(:metabase_dashboard_ids) { [1, 2, 3] }

        it "renders the index view" do
          within ".card#metabase" do
            expect(page).to have_selector("iframe[data-dashboard='0']")
            expect(page).to have_selector("iframe[data-dashboard='1']")
            expect(page).to have_selector("iframe[data-dashboard='2']")
          end
        end
      end

      context "when there is no dashboards" do
        let(:metabase_dashboard_ids) { [] }

        it "display not found message" do
          within ".card#metabase" do
            expect(page).to have_content("No dashboard found")
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
