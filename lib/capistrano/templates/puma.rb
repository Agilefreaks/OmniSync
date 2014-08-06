#!/usr/bin/env puma

directory '/var/www/omnisync/current'
rackup '/var/www/omnisync/current/config.ru'
environment ENV['RACK_ENV']

pidfile '/var/www/omnisync/shared/tmp/pids/puma.pid'
state_path '/var/www/omnisync/shared/tmp/pids/puma.state'
stdout_redirect '/var/www/omnisync/shared/log/puma_access.log', '/var/www/omnisync/shared/log/puma_error.log', true

threads 0, 4

bind 'unix:/var/www/omnisync/shared/tmp/sockets/puma.sock'
workers 4

preload_app!

on_restart do
  puts 'Refreshing Gemfile'
  ENV['BUNDLE_GEMFILE'] = '/var/www/omnisync/current/Gemfile'
end
