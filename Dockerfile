# syntax=docker/dockerfile:1
# Production image, deployed with Kamal (config/deploy.yml).
# Development uses Dockerfile.dev via docker-compose.

ARG RUBY_VERSION=4.0.7
FROM docker.io/library/ruby:${RUBY_VERSION}-slim-trixie AS base

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl libgeos-c1t64 libjemalloc2 libpq5 libyaml-0-2 shared-mime-info && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"

# Build stage: compilers, Node and Yarn stay out of the final image.
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential git libgeos-dev libpq-dev libyaml-dev && \
    curl -fsSL https://deb.nodesource.com/setup_24.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install -g yarn@1.22.22 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY Gemfile Gemfile.lock .ruby-version ./
RUN gem install bundler -v "$(tail -1 Gemfile.lock | tr -d ' ')" && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

RUN bundle exec bootsnap precompile app/ lib/

# Compile Shakapacker packs and Sprockets assets without the real master key.
RUN SECRET_KEY_BASE_DUMMY=1 DEFAULT_URL_HOST=build.invalid NODE_ENV=production ./bin/rails assets:precompile && \
    rm -rf node_modules tmp/cache

# Final image
FROM base

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p db log storage tmp && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
