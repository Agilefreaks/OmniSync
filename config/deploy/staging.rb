set :deploy_to, '/var/www/omnisync'
set :branch, 'staging'

role :app, %w(deploy@178.62.225.139)
role :web, %w(deploy@178.62.225.139)
