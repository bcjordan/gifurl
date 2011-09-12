source 'http://rubygems.org'

gem "rails", "3.1.0"

gem 'thin'

gem 'json'
gem 'sass'
gem 'jquery-rails'

## Rails 3.1 asset pipeline
# Asset template engines
group :assets do
  gem 'sass-rails', "~> 3.1.0.rc"
  gem 'coffee-script'
  gem 'uglifier'
end

## Heroku
group :production do
  gem 'pg'
end

group :development do
  gem 'sqlite3'
  gem 'ruby-debug'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

## Rails 3.1 javascript
gem 'jquery-rails'


## Custom items:
gem 'shoulda'
gem 'impressionist'
gem 'haml'
gem 'haml-rails'
gem 'nokogiri'
gem 'json'
gem 'nifty-generators'
gem 'acts-as-taggable-on'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
