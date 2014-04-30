$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app', 'api'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

# require initializers
Dir[Pathname.new(__FILE__).dirname.join('initializers', '*.rb')].each do |file|
  require file
end

require File.expand_path('../../app/omnisync_app.rb', __FILE__)
