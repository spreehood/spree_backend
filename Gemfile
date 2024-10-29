source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.0.rc1"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"
gem "sprockets-rails"
gem "mini_racer", platforms: %i[ ruby jruby ] # fixes Could not find a JavaScript runtime. See https://github.com/rails/execjs for a list of available runtimes. (ExecJS::RuntimeUnavailable) in Docker env

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "mission_control-jobs"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  gem 'listen'

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  gem 'rspec_junit_formatter'

  # monitoring
  gem 'rack-mini-profiler', require: false
  gem 'flamegraph'
  gem 'stackprof'
  gem 'memory_profiler'

  gem 'webmock'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem 'letter_opener'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'vcr'
end

gem 'spree', '~> 4.10.1'
gem 'spree_core', '~> 4.10.1'
gem 'spree_api', '~> 4.10.1'
gem 'spree_sample', '~> 4.10.1'
gem 'spree_emails', '~> 4.10.1'
gem 'spree_backend', '~> 4.8.0'
gem 'spree_auth_devise', '~> 4.6.0'
gem 'spree_i18n', '~> 5.3.0'
gem 'spree_dev_tools', require: false, group: %w[test development]

gem 'spree_social', github: 'spreehood/spree_social', branch: 'api-for-facebook-login'

gem 'spree_gateways_nepal', github: 'spreehood/spree_gateways_nepal', branch: 'feature/khalti-integration'

gem 'spree_stripe_express_checkout', github: 'spreehood/spree_stripe_express_checkout', branch: 'feature/express_checkout'

gem 'spree_multi_vendor', github: 'spreehood/spree_multi_vendor', branch: 'fix/shipping_methods_fix_in_vendors'

gem 'spree_slider', github: 'spreehood/spree_slider', branch: '2024'

gem 'spree_products_qa', github: 'spreehood/spree_products_qa', branch: 'fix/vendor-questions-fetch'

gem 'spree_reviews', github: 'spreehood/spree_reviews', branch: 'fix/vendor-reviews-fetch'

gem 'spree_kiosk', github: 'spreehood/spree_kiosk', branch: 'feature/qr_for_display'

gem 'spree_product_videos', github: 'spreehood/spree_product_videos', branch: 'fix/video-fetch-fixes'

# Rack CORS Middleware
gem 'rack-cors'

# SendGrid
gem 'sendgrid-actionmailer'

# logging
gem 'remote_syslog_logger'

gem 'activerecord-nulldb-adapter'

# file uploades & assets
gem 'aws-sdk-s3', require: false

gem 'multi_json'

# improved JSON rendering performance
gem 'oj'

gem 'mini_magick'