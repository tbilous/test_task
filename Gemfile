source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.2'
gem 'sass-rails', '~> 5.0'
gem 'thor', '0.19.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'jquery-rails'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# my gems
gem 'bootstrap-sass', '3.3.7'
gem 'devise', '4.3.0'
gem 'devise-bootstrap-views', '0.0.11'
gem 'devise-i18n', '1.2.0'
gem 'font-awesome-rails', '4.7.0.2'
gem 'faker', '1.8.4'
gem 'i18n', '0.8.6'
gem 'i18n-js', '3.0.1'
gem 'kaminari', '1.0.1'
gem 'rails-i18n', '5.0.4'
gem 'responders', '2.4.0'
gem 'rspec', '3.6.0'
gem 'slim', '3.0.8'
gem 'slim-rails', '3.1.2'
gem 'stateful_enum', '0.4.0'

# json response
gem 'active_model_serializers', '0.10.6'
gem 'oj', '3.3.5'
gem 'oj_mimic_json', '1.0.1'
gem 'skim'
gem 'twitter-typeahead-rails', '0.11.1'

group :development, :test do
  gem 'parallel_tests', '2.14.2'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'childprocess', '0.7.1'
  gem 'factory_girl_rails', '4.8.0'
  gem 'pry-byebug', '3.4.2'
  gem 'pry-rails', '0.3.6'
  gem 'rails-controller-testing', '1.0.2'
  gem 'rspec-rails', '3.6.1'
  gem 'timecop', '0.9.1'
end

group :development do
  gem 'bullet', '5.6.1'
  gem 'listen', '3.1.5'
  gem 'rubocop', '0.49.1', require: false
  gem 'spring', '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'web-console', '3.5.1'
end

group :test do
  gem 'capybara', '2.13.0'
  gem 'capybara-email', '2.5.0'
  gem 'capybara-webkit', '1.14.0'
  gem 'database_cleaner', '1.6.1'
  gem 'fuubar', '2.2.0'
  gem 'geckodriver-helper'
  gem 'json_spec', '1.1.5'
  gem 'launchy', '2.4.3'
  gem 'poltergeist', '1.16.0'
  gem 'rack_session_access', '0.1.1'
  gem 'selenium-webdriver', '2.53.4'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
