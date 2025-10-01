class IngredientListsController < ApplicationController
  def index
    @ingredient_lists = current_user.ingredient_lists
  end

  def create
    l = IngredientList.new(user: current_user, title: "Untitled list")
    if l.save
      # List created successfully
      flash[:notice] = "New ingredient list created successfully"
    else
      # Ingredient List creation failed
      flash[:alert] = l.errors.full_messages.join(", ")
    end

    redirect_to ingredient_lists_path
  end

  # DELETE /ingredient_lists/:id
  def destroy
    l = IngredientList.find_by(id: params[:id])
    if l.present?
      l.destroy # Leads to deletion from database

  # Dedicated action for the legacy `/add-ingredients` endpoint. Kept as a
  # separate action so the two public routes map to distinct controller
  # methods (avoids confusion when tracing requests). Reuse the same view.
  def add_ingredients
    # Render the same UI as `show` when called without an :id. Intentionally
    # do not load `current_user` collections here to keep behavior identical
    # to the existing non-id show path used in tests.
    render :show
  end
      flash[:notice] = "Ingredient List removes successfully"
    else
      flash[:alert] = "Ingredient list with id #{params[:id]} not found"
    end

    redirect_to ingredient_lists_path
  end

  # GET /ingredient_lists/:id
  def show
    # Support two usages:
    # - /ingredient-list -> render the add-ingredients UI for current_user
    # - /ingredient_lists/:id -> show a specific list by id
    if params[:id].present?
      @ingredient_list = IngredientList.find_by(id: params[:id])
      if @ingredient_list.nil?
        flash[:alert] = "Ingredient list with id #{params[:id]} not found"
        redirect_to ingredient_lists_path
      end
    else
      # No id provided — render the shared add-ingredients UI. Do not access
      # `current_user.ingredient_lists` here because system/request specs stub
      # `current_user` with a lightweight double that may not implement that
      # method; the UI doesn't require the collection to render.
      render :show
    end
  end

  # Search endpoint for ingredient lookups. Supports both JSON (AJAX) and
  # HTML to allow a no-JS fallback for the add-ingredients UI.
  def ingredient_search
    q = params[:q].to_s.strip
    normalized_q = q.present? ? q.singularize : q
    items = normalized_q.present? ? MealDbClient.search_ingredients(normalized_q) : []

    respond_to do |format|
      format.json { render json: { ingredients: items } }
      format.html do
        # Server-render the full add-ingredients UI so non-JS users get a
        # complete page. The `show` template will render the partial when
        # `@search_items` is present.
        @search_items = items
        render :show
      end
    end
  rescue => e
    Rails.logger.warn("[ingredient_search] #{e.class}: #{e.message}")
    respond_to do |format|
      format.json { render json: { ingredients: [] }, status: :bad_gateway }
      format.html do
        @search_items = []
        render :show, status: :bad_gateway
      end
    end
  end
end
