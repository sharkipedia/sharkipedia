FROM ruby:3.3.10-slim-bookworm

# System dependencies for Rails + PostGIS + Node
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      curl \
      git \
      libpq-dev \
      libgeos-dev \
      libproj-dev \
      proj-bin \
      gdal-bin \
      libgdal-dev \
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
RUN bundle install --jobs 4

# Install JS dependencies (layer caching)
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy the rest of the application
COPY . .

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
