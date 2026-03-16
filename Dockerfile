# Use official Ruby image as base
FROM ruby:3.3.5-slim

# Set working directory
WORKDIR /homedecor

# Production defaults (and smaller memory spikes for Node)
ENV RAILS_ENV=production \
    RACK_ENV=production \
    NODE_ENV=production \
    NODE_OPTIONS=--max_old_space_size=512

# Install system dependencies (including Node.js and Yarn properly)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    curl \
    git \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn \
    && rm -rf /var/lib/apt/lists/*

# Copy Gemfile and Gemfile.lock first for better caching
COPY Gemfile Gemfile.lock ./

# Install gems with optimized settings for t3.micro
RUN bundle config set --local without 'development test' && \
    bundle config set --local jobs 2 && \
    bundle config set --local retry 3 && \
    bundle install

# Copy package.json and yarn.lock for better caching
COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile

# Copy application code
COPY . .

RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Expose port
EXPOSE 3000

# Set default command
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
