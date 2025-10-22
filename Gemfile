# frozen_string_literal: true
source "https://rubygems.org"

# Core Rails
gem "rails", "~> 8.1.0"

# Database
gem "pg", "~> 1.1"

# Web Server
gem "puma", ">= 5.0"

# Authentication & Security
gem "bcrypt"      # for has_secure_password
gem "jwt"         # for JWT token handling

# CORS (Frontend access)
gem "rack-cors"

# JSON Serialization
gem "active_model_serializers"

# Background Jobs & Cache
gem "sidekiq"
gem "redis"

# Performance
gem "bootsnap", require: false

# Deployment
gem "kamal", require: false  # optional: for Docker-based deployment
gem "thruster", require: false # optional: HTTP compression, caching

# Timezone support (for Windows JRuby only)
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Background Task Framework (Rails 8 built-in)
gem "solid_queue"
gem "solid_cache"
gem "solid_cable"

# Development & Test Group
group :development, :test do
  gem "dotenv-rails", require: "dotenv/load"  # for .env secrets
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "rspec-rails"                            # for testing
  gem "brakeman", require: false               # for security scans
  gem "rubocop-rails-omakase", require: false  # for Ruby linting
end
