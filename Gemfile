source "https://rubygems.org"
ruby "3.3.4"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "7.1.3.3"

# Please: keep the gem declarations sorted.
#   This will make future mergings MUCH easier. <3
# gem "rails_semantic_logger"
gem "active_storage_validations"
gem "acts-as-taggable-on"
gem "amazing_print"
gem "authlogic"
gem "aws-sdk-s3", require: false
gem "bluecloth"
gem "bootsnap", require: false
gem "chartkick"
gem "cronex"
gem "data_migrate"
gem "dotenv-rails"
gem "faker"
gem "fast_blank"
gem "i18n-tasks"
gem "image_processing"
gem "importmap-rails"
gem "jbuilder"
gem "jquery-rails"
gem "kaminari"
gem "log_book"
gem "mysql2", "0.5.6"
gem "oj"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection", "~> 1.0"
gem "open_router"
gem "openai"
gem "opentelemetry-exporter-otlp"
gem "opentelemetry-instrumentation-mysql2"
gem "opentelemetry-instrumentation-net_http"
gem "opentelemetry-instrumentation-rack"
gem "opentelemetry-instrumentation-rails"
gem "pg" # For dashboard db connection with Sequel
gem "prometheus-client"
gem "puma"
gem "rack-cors"
gem "redcarpet"
gem "rexml"
gem "rollbar"
gem "ruby_regex", git: "https://github.com/fguillen/ruby_regex.git"
gem "ruby-openai"
gem "safe_ruby", git: "https://github.com/jeromeag/safe_ruby.git"
gem "scrypt"
gem "sendgrid-actionmailer"
gem "sequel"
gem "shortuuid"
gem "sidekiq-cron", "2.0.0.rc1"
gem "sidekiq"
gem "sprockets-rails"
gem "sqlite3"
gem "stimulus-rails"
gem "strip_attributes"
gem "style_palette"
gem "tiktoken_ruby" # OpenAI dependency, if not I get error cannot load such file -- tiktoken_ruby
gem "turbo-rails"
gem "turnstile-captcha", require: "turnstile" # Cloudflare Turnstile Captcha
gem "tzinfo-data"
gem "uglifier"
gem "uuid"
gem "virtus-relations"
gem "virtus"


group :test do
  gem "factory_bot"
  gem "minitest"
  gem "mocha"
  gem "rails-controller-testing"
  gem "simplecov", require: false
end

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "http_logger"
  gem "timecop"
end

group :development do
  gem "brakeman"
  gem "bundle-audit"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
  gem "spring-watcher-listen"
  gem "spring"
  gem "web-console"
end

# Use Redis for Action Cable
gem "redis", "~> 4.0"

gem "dockerfile-rails", ">= 1.6", :group => :development
