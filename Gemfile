source "https://rubygems.org"
ruby "2.3.1"

gem "rails", "~> 5.0.0", ">= 5.0.0.1"
gem "sqlite3"
gem "puma", "~> 3.0"
gem "carrierwave"
gem "carrierwave-base64"
gem "kaminari"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  gem "byebug", platform: :mri
  gem "rspec-rails"
  gem "factory_girl_rails"
end

group :development do
  gem "listen", "~> 3.0.5"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "shoulda-matchers"
  gem "webmock"
  gem "database_cleaner"
end
