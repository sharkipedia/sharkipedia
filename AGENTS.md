# AGENTS.md — Sharkipedia

## Project Overview

Rails 8.1 application (Ruby 4.0, Node 24 LTS) for managing shark/ray species data,
trait observations, population trends, and academic references. Uses PostGIS for
geospatial queries, Shakapacker 10 with React 19 for frontend components, and Devise/Pundit
for authentication/authorization.

## Build & Run Commands

### Docker (recommended)

`bin/setup` provisions the stack; `bin/dev` boots it. Both wrap
`docker compose` and work on Apple Silicon and Intel out of the box.

```bash
# One-shot: build images, install gems/node, prepare DB, start the app.
# Add --skip-server to stop before booting.
bin/setup

# Start all services (web :3000, shakapacker :3035, good_job worker, db, redis)
bin/dev

# Run commands inside the containers
docker compose run --rm web bundle exec rspec
docker compose run --rm web yarn test
docker compose run --rm web bin/rails console
docker compose run --rm web bin/standardrb
docker compose exec web bash

docker compose down              # stop
docker compose down -v           # stop + wipe DB volume
```

After changing `Gemfile` or `package.json`, rerun `bin/setup`.

### Native

```bash
# Install dependencies
bundle install
yarn install

# Database setup (requires PostGIS)
bin/rails db:create db:schema:load

# Start development servers (web + webpack-dev-server + good_job worker)
foreman start -f Procfile.dev

# Asset compilation
bin/shakapacker
```

## Lint Commands

```bash
# Ruby linting (Standard Ruby — the ONLY Ruby linter)
bin/standardrb                 # check
bin/standardrb --fix           # auto-fix

# No JS linter is configured (no ESLint/Prettier)
```

## Test Commands

```bash
# Run all Ruby specs
bundle exec rails spec

# Run a single spec file
bundle exec rspec spec/models/species_spec.rb

# Run a single test by line number
bundle exec rspec spec/models/species_spec.rb:42

# Run specs matching a pattern
bundle exec rspec --tag focus
bundle exec rspec -e "validates presence"

# Run specs by directory
bundle exec rspec spec/models/
bundle exec rspec spec/controllers/
bundle exec rspec spec/system/

# Run all JavaScript tests
yarn test

# Run a single JS test file
yarn test spec/javascript/TrendChart.spec.js

# Run JS tests with coverage
yarn test --coverage
```

## Code Style — Ruby

- **Formatter/Linter**: Standard Ruby (standardrb). No custom RuboCop rules.
- **Strings**: Double quotes (`"string"`), which is the Standard Ruby default.
- **Hash syntax**: Ruby 3.1 shorthand where applicable (`scope.where(user:)`).
- **Method definitions**: No parentheses for zero-arg methods; parentheses when args are present.
- **Imports**: Rails autoloading handles most requires. Explicit `require` only for `lib/` code.
- **No trailing commas** in argument or hash lists (not enforced but convention in codebase).

## Code Style — JavaScript

- **React 19** functional components (arrow functions, not class components).
- **PropTypes** for prop validation (no TypeScript).
- **ES6 imports**: `import React from "react"`, `import PropTypes from "prop-types"`.
- **Default exports** for React components.
- **Test files**: `spec/javascript/ComponentName.spec.js` using `@testing-library/react` and Jest.
- **Component registration**: Components in `app/javascript/components/` are auto-discovered
  via `require.context` and rendered server-side through `react-rails`.

## Naming Conventions

| Entity       | Convention                    | Example                          |
|------------- |-------------------------------|----------------------------------|
| Model        | Singular PascalCase           | `Species`, `TrendObservation`    |
| Controller   | Plural + `Controller`         | `TrendsController`               |
| Policy       | Model + `Policy`              | `ImportPolicy`                   |
| Serializer   | Model + `Serializer`          | `SpeciesSerializer`              |
| Dashboard    | Model + `Dashboard`           | `SpeciesDashboard`               |
| Service      | Namespaced module             | `Export::Traits`, `Xlsx::Validator` |
| Job          | Action + `Job`                | `ImportJob`                      |
| Spec file    | Mirrors app path + `_spec.rb` | `spec/models/species_spec.rb`    |
| System spec  | `*_system_spec.rb`            | `authentication_system_spec.rb`  |
| JS component | PascalCase `.js`              | `TrendChart.js`                  |

## Architecture Patterns

### Authentication & Authorization

- **Devise** for user auth. `ApplicationController` enforces `before_action :authenticate_user!`.
- **Public controllers** inherit from `PreAuthController` which skips auth.
- **Pundit** for authorization. Call `authorize @record` in controller actions.
- **User roles** (hierarchical): `user` < `contributor` < `editor` < `admin`.
  Role stored as string in `user_level` column. Helper methods: `admin?`, `editor?`, etc.
- **API auth**: HTTP Token authentication, separate from Devise.

### Service Objects

- Inherit from `ApplicationService` which provides `self.call(...)` class method.
- Instance method `#call` contains the logic. Usage: `Export::Traits.call(params)`.

### State Machine

- `Import` model uses AASM: `uploaded -> pending_review -> approved -> imported -> published`.
- Transitions trigger mailer notifications and background jobs.

### Background Jobs

- **GoodJob 4** (PostgreSQL-based) as ActiveJob backend.
- Cron jobs defined in `config/application.rb`.

### Data Layer

- **PostGIS** adapter with `rgeo`. Spatial queries use `ST_Intersects`.
- **PaperTrail** enabled on all models via `ApplicationRecord` (`has_paper_trail`).
- **FriendlyId** for URL slugs on `Species`.
- **Pagy 43** for pagination (not Kaminari/will_paginate). Controllers `include Pagy::Method`; views call `@pagy.series_nav(:bulma)`.

### Frontend

- **Shakapacker 10** with Babel 8 (Webpacker's community successor; not jsbundling/importmaps).
- **Bulma CSS** framework — use classes like `is-primary`, `columns`, `column`, `table`.
- **ERB views** with React components embedded via `react_component` helper.
- **Turbolinks** enabled for page navigation.
- **Select2** for enhanced dropdowns, **Chart.js 4** for charts, **OpenLayers** for maps.
- `package.json` `resolutions` forces `react_ujs` onto the app's React. Without it, react_ujs
  pulls in its own React 18 and every component fails to mount.
- Component CSS is extracted to files and loaded by `stylesheet_pack_tag` in the layout.

## Error Handling

- `ApplicationController` rescues `Pundit::NotAuthorizedError` (redirect + flash)
  and `ActiveRecord::RecordNotFound` (Bugsnag notify in production, redirect).
- Background jobs rescue exceptions with `Bugsnag.notify(e)` and log to the import record.
- Use standard ActiveModel validations. Custom validators go in `app/validators/`.
- The only custom validator is `DOIValidator` (validates DOI format on references).

## Testing Conventions

- **RSpec** with `rspec-rails`. Spec type inferred from file location.
- **FactoryBot**: All factories in a single `spec/factories.rb` file. Use `create(:model)`
  and `build(:model)`. `FactoryBot::Syntax::Methods` is included globally.
- **Shoulda Matchers**: Use one-liner syntax for association/validation tests.
- **System specs**: Require `system_helper` (not `rails_helper`). Use Capybara + Selenium
  headless Chrome. Files go in `spec/system/` with `_system_spec.rb` suffix.
- **API specs**: Use `set_token` helper from `spec/support/api.rb` for token auth.
- **Controller specs**: Use `login_admin` / `login_user` from `spec/support/devise.rb`.
- Transactional fixtures enabled. No database_cleaner.

## Database

- **PostgreSQL with PostGIS** — adapter is `postgis`, not `postgresql`.
- Schema format: `db/schema.rb` (Ruby format, not SQL).
- Extensions: `pgcrypto`, `plpgsql`, `postgis`.
- EEZ geographic data loaded externally (not in seeds).
- Marine region polygons (Longhurst, FAO, MEOW, PPOW) are loaded with
  `bin/rails regions:load` (fetches from VLIZ and UNEP-WCMC; idempotent; not in seeds).

## CI Pipeline (GitHub Actions)

Two jobs on push/PR to `master`:

1. **Linters**: `bin/standardrb`
2. **Tests**: PostGIS + Redis services, schema load, `bundle exec rails spec`, `yarn test`

## Key Files

- `config/routes.rb` — all routes
- `app/models/concerns/describable.rb` — shared model concern
- `app/controllers/pre_auth_controller.rb` — base for public controllers
- `app/serializers/base_serializer.rb` — base for JSONAPI serializers
- `app/services/application_service.rb` — base service object
- `spec/factories.rb` — ALL test factories (single file)
- `spec/support/` — shared test helpers (devise, api, factory_bot, shoulda, jsonapi)
