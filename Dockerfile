# Use official Ruby image as base
FROM ruby:3.3.5-slim

# Set working directory
WORKDIR /homedecor

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    nodejs \
    npm \
    yarn \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --jobs=4 --retry=3

# Copy application code
COPY . .

# Install Node dependencies
RUN yarn install

# Precompile assets
RUN bundle exec rails assets:precompile

# Expose port
EXPOSE 3000

# Set default command
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
