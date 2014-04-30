source 'http://rubygems.org'
ruby '2.1.1'

gem 'puma'
gem 'faye-websocket'
gem 'wamp'

gem 'grape'
gem 'grape-entity'
gem 'grape-swagger'

gem 'bundler'
gem 'rake'

gem 'newrelic_rpm'
gem 'newrelic-grape'

group :development do
  gem 'bundler'

  gem 'pry'
  gem 'pry-nav'

  gem 'guard-rspec'

  gem 'rubocop'

    # deploy
  gem 'capistrano', '~> 3.1.0', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano3-puma', require: false
end

group :test do
  gem 'rspec'
  gem 'rspec-mocks'

  gem 'rack-test'
end