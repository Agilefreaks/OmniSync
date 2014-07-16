set :deploy_to, '/var/www/omnisync'
set :branch, 'staging'

role :app, %w(deploy@5.10.81.85)
role :web, %w(deploy@5.10.81.85)
