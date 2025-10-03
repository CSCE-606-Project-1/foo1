# MealMatch Codebase Overview

This document provides a narrative companion to the generated YARD API reference. It highlights the major entry points in the application and where to look when you are extending the ingredient list experience.

## Key Components

- **Controllers**
  - `IngredientListsController` manages CRUD for ingredient lists and powers the add-ingredients UI (HTML and JSON responses).
  - `DashboardController` surfaces the logged-in landing page and anchors the ingredient modal entry point.
  - `RecipesController` exposes the recipe search endpoint that consumes ingredient lists.
- **Models**
  - `IngredientList`, `Ingredient`, and `IngredientListItem` define the many-to-many relationship backing saved ingredient collections.
  - `User` owns ingredient lists; authentication is handled upstream (see `ApplicationController#current_user`).
- **Services**
  - `MealDbClient` is the integration point with TheMealDB API. It memoizes the ingredient catalog and exposes a lightweight search helper used by Stimulus and the no-JS fallback.

## Front-End Architecture

- Stimulus controllers live in `app/javascript/controllers/` and are auto-registered via the generated `index.js` manifest.
- The ingredient modal is progressively enhanced: the markup in `app/views/ingredient_lists/show.html.erb` works without JavaScript, while `ModalController` and `IngredientSearchController` provide richer interactions when JS is enabled.

## Documentation & Testing Notes

- Specs under `spec/requests/ingredients_list_manager/` exercise both Stimulus-enhanced flows and the no-JS fallback.
- The YARD configuration excludes rendered assets and adds these prose guides to the generated reference. Run `yard doc --plugin rspec` to refresh documentation and `yard server --reload` to browse at <http://localhost:8808>.

## Adding Documentation

- Prefer YARD-style docstrings (`##` with `@param`, `@return`, etc.) directly above methods and classes.
- Group related helpers with `@!group` directives if a class exposes multiple public entry points.
- Keep external integration details (API requirements, caching semantics) at the class level—see `MealDbClient` for an example.

For broader onboarding material (environment setup, deployment), continue to rely on the project README.
