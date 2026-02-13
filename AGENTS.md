# AGENTS.md — Sharkipedia

## Project Overview

Rails 7.1 application (Ruby 3.2.2, Node 16.x) for managing shark/ray species data,
trait observations, population trends, and academic references. Uses PostGIS for
geospatial queries, Webpacker 5.4 with React 17 for frontend components, and Devise/Pundit
for authentication/authorization.

## Build & Run Commands

```bash
# Install dependencies
bundle install
yarn install

# Database setup (requires PostGIS)
bin/rails db:create db:schema:load

# Start development servers (web + webpack-dev-server + good_job worker)
bin/dev                        # or: foreman start -f Procfile.dev

# Asset compilation
bin/webpack
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

- **React 17** functional components (arrow functions, not class components).
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

- **GoodJob** (PostgreSQL-based) as ActiveJob backend.
- Cron jobs defined in `config/application.rb`.

### Data Layer

- **PostGIS** adapter with `rgeo`. Spatial queries use `ST_Intersects`.
- **PaperTrail** enabled on all models via `ApplicationRecord` (`has_paper_trail`).
- **FriendlyId** for URL slugs on `Species`.
- **Pagy** for pagination (not Kaminari/will_paginate).

### Frontend

- **Webpacker 5.4** (not jsbundling/importmaps).
- **Bulma CSS** framework — use classes like `is-primary`, `columns`, `column`, `table`.
- **ERB views** with React components embedded via `react_component` helper.
- **Turbolinks** enabled for page navigation.
- **Select2** for enhanced dropdowns, **Chart.js 2.x** for charts, **OpenLayers** for maps.

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
