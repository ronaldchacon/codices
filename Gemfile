source "https://rubygems.org"
ruby "2.3.3"

gem "rails", "~> 5.0.0", ">= 5.0.0.1"
gem "pg"
gem "puma", "~> 3.0"
gem "carrierwave"
gem "carrierwave-base64"
gem "kaminari"
gem "pg_search"
gem "bcrypt"
gem "pundit"
gem "money-rails"
gem "stripe"
gem "figaro"
gem "oj"
gem "rack-cors", require: "rack/cors"

group :development, :test do
  gem "byebug", platform: :mri
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "vcr"
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
