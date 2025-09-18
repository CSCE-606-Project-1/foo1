# spec/system/dashboard/add_ing_modal_spec.rb
# (folder "system" optional; you already have `type: :system`)
require "rails_helper"
require "ostruct"

RSpec.describe "Dashboard Add Ingredients modal", type: :system do
  let(:user) { OpenStruct.new(first_name: "Test", last_name: "User", email: "test@example.com") }

  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  it "is hidden by default, opens on click, and closes on Close or ESC" do
    visit "/dashboard"

    # Guard so we fail loudly if something redirects us
    expect(page).to have_current_path("/dashboard", ignore_query: true)
    expect(page).to have_button("Add Ingredients +")

    expect(page).to have_selector("#ingredients-modal[hidden]", visible: :all)

    click_button "Add Ingredients +"
    expect(page).to have_selector("#ingredients-modal:not([hidden])", visible: :all)
    expect(page).to have_content("Add Ingredients")

    find("#ingredients-close-btn").click
    expect(page).to have_selector("#ingredients-modal[hidden]", visible: :all)

    click_button "Add Ingredients +"
    expect(page).to have_selector("#ingredients-modal:not([hidden])", visible: :all)

    find("body").send_keys(:escape)
    expect(page).to have_selector("#ingredients-modal[hidden]", visible: :all)
  end
end
