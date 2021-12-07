# frozen_string_literal: true

require "spec_helper"

describe "Admin manages Metabase", type: :system do
  let(:organization) { create(:organization) }
  let!(:admin) { create(:user, :admin, :confirmed, organization: organization) }

  before do
    switch_to_host(organization.host)
    login_as admin, scope: :user
    visit decidim_admin.root_path
  end

  it "menu contains Metabase link" do
    within "nav.main-nav" do
      expect(page).to have_content("Metabase")
      expect(page).to have_selector("a[href='/admin/metabase']")
    end
  end
end
