require "rails_helper"

RSpec.describe "Logout", type: :system do
  let(:user) do
    User.create!(email: "solidsnake@gmail.com",
                 first_name: "Solid",
                 last_name: "Snake")
  end

  before do
    # Bypass authentication
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  # We should not see the "Logout" button for these
  # pages
  #
  # NOTE: I am deliberately using symbol names here and not
  # login_path, dashboard_path as that tries to call those methods
  # when the array is instantiated which we don't want. (In case of some
  # end points that expect a mandatory URI parameter, that won't even work
  # due to exceptions getting raised.
  let(:excluded_paths) { [ :login_path ] }

  # We should see the "Logout" button for these pages, though
  # this does not include all the paths used by meal match where we should
  # see the button (everything except excluded paths), it should
  # suffice
  #
  # NOTE: I am deliberately using symbol names here and not
  # login_path, dashboard_path as that tries to call those methods
  # when the array is instantiated which we don't want. (In case of some
  # end points that expect a mandatory URI parameter, that won't even work
  # due to exceptions getting raised.
  let(:included_paths) {
      [
        # GET /ingredient_lists/ (INDEX page)
        :ingredient_lists_path,

        # GET /ingredient_lists/:ingredient_list_id
        :ingredient_list_path,

        # GET /recipes_search/:ingredient_list_id
        :recipes_search_path
      ]
  }

  let(:button_id) { "logout-btn" }

  it "should NOT show the button in case of excluded paths" do
    excluded_paths.each do |path|
      visit send(path)
      expect(page).not_to have_button(id: button_id)
    end
  end

  it "should show the button in case of non excluded paths" do
    ingredient_lst_1 = IngredientList.create!(user: user, title: "List 1")

    included_paths.each do |path|
      if path == :recipes_search_path
        # Tries to search recipes corresponding to l1
        # Below call is equivalent to:
        # recipes_search_path(ingredient_lst_1)
        visit send(path, ingredient_lst_1)
        expect(page).to have_button(id: button_id)
      elsif path == :ingredient_list_path
        # GET /ingredient_lists/:ingredient_list_id
        # ingredient_list_path(ingredient_lst_1)
        visit send(path, ingredient_lst_1)
        expect(page).to have_button(id: button_id)
      else
        visit send(path)
        expect(page).to have_button(id: button_id)
      end
    end
  end
end
