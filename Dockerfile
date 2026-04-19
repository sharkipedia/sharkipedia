FROM ruby:4.0.2-slim-bookworm

# System dependencies for Rails + PostGIS + Node + headless browser
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      chromium \
      chromium-driver \
      curl \
      git \
      libpq-dev \
      libgeos-dev \
      libproj-dev \
      proj-bin \
      gdal-bin \
      libgdal-dev \
      libyaml-dev \
      postgresql-client \
      shared-mime-info \
    && rm -rf /var/lib/apt/lists/*

# Install Node 20.x and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Ruby dependencies first (layer caching)
COPY Gemfile Gemfile.lock .ruby-version ./
# The lockfile's BUNDLED WITH may predate Ruby 4; make sure we have a bundler
# new enough to boot on the current Ruby.
RUN gem update --system --silent && gem install bundler
RUN bundle install --jobs 4

# Install JS dependencies (layer caching)
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy the rest of the application
COPY . .

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
