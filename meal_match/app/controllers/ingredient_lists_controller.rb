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
end
