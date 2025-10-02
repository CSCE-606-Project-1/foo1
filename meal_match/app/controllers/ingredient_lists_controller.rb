class IngredientListsController < ApplicationController
  before_action :load_ingredient_list, only: %i[show update destroy]
  before_action :ensure_ingredient_list, only: %i[show update destroy], if: -> { params[:id].present? }

  def index
    @ingredient_lists = current_user.ingredient_lists
  end

  def create
    list = current_user.ingredient_lists.build(title: "Untitled list")
    if list.save
      flash[:notice] = "New ingredient list created successfully"
    else
      flash[:alert] = list.errors.full_messages.join(", ")
    end

    redirect_to ingredient_lists_path
  end

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
  def add_ingredients
    @ingredient_list = nil
    @selected_ingredients = []
    render :show
  end

  # GET /ingredient_lists/:id
  def show
    if params[:id].blank?
      @selected_ingredients = []
      return
    end

    @selected_ingredients = build_selected_ingredients(list: @ingredient_list)
  end

  # PATCH /ingredient_lists/:id
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

  def ensure_ingredient_list
    return if @ingredient_list.present?

    flash[:alert] = "Ingredient list with id #{params[:id]} not found"
    redirect_to ingredient_lists_path
  end

  def permitted_list_params
    params.fetch(:ingredient_list, {}).permit(:title, selected_ingredient_ids: [])
  end

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

  def find_ingredient_list(id)
    return if id.blank?

    if current_user.respond_to?(:ingredient_lists)
      current_user.ingredient_lists.includes(:ingredients).find_by(id: id)
    else
      IngredientList.includes(:ingredients).find_by(id: id)
    end
  end

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
