set :deploy_to, '/var/www/omnisync'
set :branch, 'production'

role :app, %w(deploy@178.62.222.23 deploy@178.62.222.26)
role :web, %w(deploy@178.62.222.23 deploy@178.62.222.26)
