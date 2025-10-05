# MealMatch

MealMatch helps users build, save, and manage ingredient lists and then find
recipes that can be made from those ingredients. It uses TheMealDB as the
recipe source and is built with Ruby on Rails.

This README covers quick local setup, configuration, testing, documentation,
and developer notes.

Table of contents
- Quick start (local)
- Environment variables
- Main user flows
- How recipe lookup works (developer details)
- Testing & linting
- Generating docs (YARD)
- Troubleshooting
- Contributing / dev notes

Quick start (local)
-------------------

Prerequisites
- Ruby (see `.ruby-version`)
- Bundler
- PostgreSQL

Install dependencies

```bash
bundle install
```

Create and prepare the database

```bash
bin/rails db:create db:schema:load db:seed
```

Set required environment variables (see "Environment variables" below):

```bash
export THEMEALDB_API_KEY=your_api_key_here_premium
export THEMEALDB_API_BASE="https://www.themealdb.com/api/json/v2"
```

Start the Rails server

```bash
bin/rails server -p 3000
```

Open the app at: http://localhost:3000

Environment variables
---------------------

- THEMEALDB_API_KEY (required) — API key for TheMealDB used by `MealDbClient`.
- THEMEALDB_API_BASE (optional) — Base URL for TheMealDB API; default
	`https://www.themealdb.com/api/json/v2`.

Postgresql Account Username and Password

- MEAL_MATCH_DATABASE_USERNAME=<username>
- MEAL_MATCH_DATABASE_PASSWORD=<password>

Main user flows
---------------

Login / Authentication
- Use the login page to authenticate (the app supports OAuth providers). For
	development you may create a `User` record directly in the DB.

Create & manage Ingredient Lists
- Create an Ingredient List (title + ingredients).
- Ingredients link via `IngredientListItem`.

Search recipes from an Ingredient List
- Click "Search Recipe" from the Dashboard or an Ingredient List view.
- The app routes to: `/recipes/ingredient_lists/:ingredient_list_id`.
- `RecipesController#search` collects ingredient names and calls
	`MealDbClient.filter_by_ingredients(ingredient_names)`.
- HTML response: renders `app/views/recipes/search.html.erb` (list of recipe
	cards). JSON response: `{ recipes: [...] }`.

How recipe lookup works (developer detail)
# MealMatch

MealMatch helps users collect, save and manage ingredient lists and then find
recipes that can be made from those ingredients. The app uses TheMealDB as the
recipe source and is built with Ruby on Rails.

This document covers developer and user-facing setup steps:
- Ruby version
- System dependencies
- Configuration (environment variables)
- Database creation & initialization
- How to run the test suite
- Services the app expects (job queues, cache servers, etc.)
- Deployment notes
- Generating documentation with YARD

---

## Ruby version

This project uses the Ruby version set in `.ruby-version`. Use a Ruby
version manager (rbenv, rvm, asdf) to install and switch to that version.

Example (rbenv):

```bash
rbenv install $(cat .ruby-version)
rbenv local $(cat .ruby-version)
```

---

## System dependencies

These are common dependencies required to run MealMatch locally:

- PostgreSQL (database)
- libpq development headers (for `pg` gem) — e.g. `libpq-dev` on Debian/Ubuntu
- A modern C compiler (GCC/Clang) for gem compilation
- Node.js is optional for front-end tooling; this app uses Importmap so Node is
	not required for basic runs.

On Ubuntu/Debian, install the essentials:

```bash
sudo apt-get update
sudo apt-get install -y build-essential libpq-dev postgresql
```

---

## Configuration (environment variables)

The app relies on a few environment variables for third-party integrations.
Set these in your shell or with a dotenv/credentials mechanism used in your
deployment.

- `THEMEALDB_API_KEY` (required) — API key for TheMealDB. The value is used by
	`app/services/meal_db_client.rb`.
- `THEMEALDB_API_BASE` (optional) — Base URL for TheMealDB. Defaults to
	`https://www.themealdb.com/api/json/v2`.

Example:

```bash
export THEMEALDB_API_KEY=your_api_key_here
export THEMEALDB_API_BASE="https://www.themealdb.com/api/json/v2"
```

Other environment/configuration is controlled by standard Rails conventions
(e.g., `config/database.yml`, `credentials.yml.enc`).

---

## Database creation & initialization

Create the database, load schema, and run seeds:

```bash
bundle install
bin/rails db:create db:schema:load db:seed
```

Notes:
- If you prefer to run migrations instead of loading the schema, run
	`bin/rails db:create db:migrate`.
- Ensure the PostgreSQL server is running and your `config/database.yml` is
	configured for your local environment.

---

## How to run the test suite

The project uses RSpec for unit and request specs.

Run the entire test suite:

```bash
bundle exec rspec
```

Run individual spec files:

```bash
bundle exec rspec spec/services/meal_db_client_spec.rb
bundle exec rspec spec/requests/recipes_search_spec.rb
```

Notes about tests:
- Tests stub external HTTP calls and environment variables where appropriate.
- Consider adding WebMock or VCR if you introduce external integration tests.

---

## Services (job queues, cache, search engines)

Out-of-the-box the app uses Rails defaults. The codebase references libraries
that can be used for background processing and caching, but these are optional
and configurable in production.

Current notable services / gems in the project:

- `solid_queue`, `solid_cache`, `solid_cable` — optional adapters used in the
	project for background jobs, caching, and Action Cable (see `Gemfile`).
- Background jobs and mailers use standard Rails `ActiveJob` and
	`ActionMailer` APIs (see `app/jobs` and `app/mailers`).

If you enable background workers in production, ensure you run the chosen
queue worker (e.g. Sidekiq, a Solid-based worker) and configure adapters
accordingly.

---

## Deployment notes

This project contains a `Dockerfile` and helper scripts for containerized
deployments. You can deploy via Docker/containers or follow standard Rails
deploy procedures.

Basic Docker build & run (example):

```bash
# build image
docker build -t mealmatch:latest .

# run container (set environment variables and ports appropriately)
docker run -e THEMEALDB_API_KEY=${THEMEALDB_API_KEY} -p 3000:3000 mealmatch:latest
```

For more advanced deployment (Kubernetes, Docker Compose, or a PaaS), ensure
your environment variables and database endpoints are provided by your
infrastructure. The repo includes `bin/kamal` utilities and sample Kamal
configs for container deployment.

---

## Generating documentation with YARD

The project includes YARD configuration and a Rake task to build documentation.
To generate docs locally:

```bash
bundle install --with development
bundle exec rake docs:yard
```

This will generate HTML documentation (typically under `doc/yard` or `doc/`).
If you prefer to run YARD directly:

```bash
bundle exec yard doc
```

YARD notes:
- The project contains `.yardopts` and `.yardignore` to control which files
	are scanned. Adjust these if you add new directories or non-Ruby files.
- If YARD reports parser warnings for non-Ruby files, update `.yardignore` or
	the Rake task manifest to exclude them.

---

## Troubleshooting

- If you see blank recipe results:
	- Verify `THEMEALDB_API_KEY` is set and valid.
	- Check `log/development.log` for HTTP or parsing errors from TheMealDB.

- If you get redirected to the login page while testing:
	- The app requires authentication for dashboard and recipe actions. Create
		a `User` record or configure your OAuth provider in `config/initializers`.

- Tests failing due to external HTTP calls:
	- Ensure tests stub HTTP requests or add WebMock/VCR to record/replay.

---

## Contributing / Developer notes

- Key files:
	- Controllers: `app/controllers/recipes_controller.rb`,
		`app/controllers/ingredient_lists_controller.rb`
	- Services: `app/services/meal_db_client.rb`
	- Views: `app/views/recipes/search.html.erb`
	- Models: `app/models/ingredient*.rb`, `app/models/ingredient_list*.rb`

- Add tests when introducing new behavior. Use `spec/services` and
	`spec/requests` for service and controller behavior respectively.

- For documentation changes, update YARD docstrings and run the docs task.

