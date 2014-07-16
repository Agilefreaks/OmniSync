set :deploy_to, '/var/www/omnisync'
set :branch, 'staging'

role :app, %w(deploy@46.16.191.70)
role :web, %w(deploy@46.16.191.70)
