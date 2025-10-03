# Controller for managing user-created ingredient lists. Supports CRUD
# actions and AJAX-backed ingredient searching used by the UI.
class IngredientListsController < ApplicationController
  before_action :load_ingredient_list, only: %i[show update destroy]
  before_action :ensure_ingredient_list, only: %i[show update destroy], if: -> { params[:id].present? }

  # List all ingredient lists for the current user.
  #
  # @return [void]
  def index
    @ingredient_lists = current_user.ingredient_lists
  end

  # Create a new, untitled ingredient list for the current user.
  #
  # @return [void]
  def create
    list = current_user.ingredient_lists.build(title: "Untitled list")
    if list.save
      flash[:notice] = "New ingredient list created successfully"
    else
      flash[:alert] = list.errors.full_messages.join(", ")
    end

    redirect_to ingredient_lists_path
  end

  # Destroy an existing ingredient list belonging to the current user.
  #
  # @return [void]
  def destroy
    if @ingredient_list.present?
      @ingredient_list.destroy
      flash[:notice] = "Ingredient list removed successfully"
    else
      flash[:alert] = "Ingredient list with id #{params[:id]} not found"
    end

    redirect_to ingredient_lists_path
  end

  # Dedicated action for the legacy `/add-ingredients` endpoint. Reuse show UI.
  #
  # @return [void]
  def add_ingredients
    @ingredient_list = nil
    @selected_ingredients = []
    render :show
  end

  # GET /ingredient_lists/:id
  #
  # @return [void]
  def show
    if params[:id].blank?
      @selected_ingredients = []
      return
    end

    @selected_ingredients = build_selected_ingredients(list: @ingredient_list)
  end

  # PATCH /ingredient_lists/:id
  #
  # @return [void]
  def update
    list_params = permitted_list_params
    selected_ids = Array(list_params.delete(:selected_ingredient_ids)).map(&:to_s).reject(&:blank?).uniq
    title = list_params.delete(:title).to_s.strip
    title = "Untitled list" if title.blank?

    ActiveRecord::Base.transaction do
      @ingredient_list.update!(title: title)
      sync_selected_ingredients(@ingredient_list, selected_ids)
    end

    flash[:notice] = "Ingredient list saved successfully"
    redirect_to ingredient_lists_path
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = e.record.errors.full_messages.join(", ")
    redirect_to ingredient_list_path(@ingredient_list)
  rescue StandardError => e
    Rails.logger.warn("[ingredient_lists#update] #{e.class}: #{e.message}")
    flash[:alert] = "We couldn't save your ingredient list. Please try again."
    redirect_to ingredient_list_path(@ingredient_list)
  end

  # Search endpoint for ingredient lookups. Supports JSON (AJAX) and HTML.
  #
  # @return [void]
  def ingredient_search
    q = params[:q].to_s.strip
    normalized_q = q.present? ? q.singularize : q
    items = normalized_q.present? ? MealDbClient.search_ingredients(normalized_q) : []

    respond_to do |format|
      format.json { render json: { ingredients: items } }
      format.html do
        @ingredient_list = find_ingredient_list(params[:ingredient_list_id])
        ingredient_params = params[:ingredient_list]
        selected_ids = ingredient_params&.[](:selected_ingredient_ids) || ingredient_params&.[]("selected_ingredient_ids")
        override = ingredient_params&.key?(:selected_ingredient_ids) || ingredient_params&.key?("selected_ingredient_ids")
        @selected_ingredients = build_selected_ingredients(
          list: @ingredient_list,
          selected_ids: selected_ids,
          override: override
        )
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

  private

  def load_ingredient_list
    return if params[:id].blank?

    @ingredient_list = find_ingredient_list(params[:id])
  end

  # Ensure the ingredient list exists for the given id, redirecting to the
  # index with an alert if not found.
  #
  # @return [void]
  def ensure_ingredient_list
    return if @ingredient_list.present?

    flash[:alert] = "Ingredient list with id #{params[:id]} not found"
    redirect_to ingredient_lists_path
  end

  # Permit list parameters from the request.
  #
  # @return [ActionController::Parameters]
  def permitted_list_params
    params.fetch(:ingredient_list, {}).permit(:title, selected_ingredient_ids: [])
  end

  # Sync the selected ingredient provider IDs into the given list. This will
  # create Ingredient records for any missing provider ids using data from
  # MealDbClient.
  #
  # @param list [IngredientList]
  # @param provider_ids [Array<String>]
  # @return [void]
  def sync_selected_ingredients(list, provider_ids)
    if provider_ids.empty?
      list.ingredients = []
      return
    end

    provider_ids = provider_ids.uniq
    existing = Ingredient.where(provider_name: Ingredient::THEMEALDB_PROVIDER, provider_id: provider_ids).index_by(&:provider_id)
    missing_ids = provider_ids - existing.keys

    if missing_ids.any?
      lookup = MealDbClient.fetch_all_ingredients.index_by { |ing| ing[:id].to_s }

      missing_ids.each do |provider_id|
        data = lookup[provider_id]
        next unless data

        ingredient = Ingredient.find_or_initialize_by(provider_name: Ingredient::THEMEALDB_PROVIDER, provider_id: provider_id)
        ingredient.title = data[:name].presence || ingredient.title || "Unnamed ingredient"
        ingredient.description = data[:description] if data[:description].present?
        ingredient.save! if ingredient.changed?
        existing[provider_id] = ingredient
      end
    end

    list.ingredients = provider_ids.map { |provider_id| existing[provider_id] }.compact
  end


  # Find an ingredient list for id. Returns nil when id is blank or record
  # cannot be found.
  #
  # @param id [String,Integer]
  # @return [IngredientList, nil]
  def find_ingredient_list(id)
    return if id.blank?

    if current_user.respond_to?(:ingredient_lists)
      current_user.ingredient_lists.includes(:ingredients).find_by(id: id)
    else
      IngredientList.includes(:ingredients).find_by(id: id)
    end
  end

  # Build a normalized array of selected ingredients for the given list and
  # requested ids. Result items are hashes with :id and :name keys.
  #
  # @param list [IngredientList, nil]
  # @param selected_ids [Array<String>]
  # @param override [Boolean] whether the provided selected_ids should replace
  #   the list contents
  # @return [Array<Hash{Symbol=>String}>]
  def build_selected_ingredients(list:, selected_ids: [], override: false)
    selected_ids = Array(selected_ids).map(&:to_s).reject(&:blank?)

    base = []

    if list
      base = list.ingredients.map do |ingredient|
        {
          id: ingredient.provider_id,
          name: ingredient.title
        }
      end
    end

    combined_ids = if override
      selected_ids
    else
      (base.map { |item| item[:id] } + selected_ids)
    end

    combined_ids = combined_ids.map(&:to_s).reject(&:blank?).uniq
    return base if combined_ids.empty? && !override
    return [] if combined_ids.empty?

    existing = Ingredient.where(provider_name: Ingredient::THEMEALDB_PROVIDER, provider_id: combined_ids).index_by(&:provider_id)
    lookup = nil

    combined_ids.map do |provider_id|
      if record = existing[provider_id]
        { id: provider_id, name: record.title }
      else
        lookup ||= MealDbClient.fetch_all_ingredients.index_by { |ing| ing[:id].to_s }
        data = lookup[provider_id]
        next unless data

        name = data[:name] || data[:title] || "Unnamed ingredient"
        { id: provider_id, name: name }
      end
    end.compact
  end
end
