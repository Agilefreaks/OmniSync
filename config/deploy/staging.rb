set :deploy_to, '/var/www/omnisync'
set :branch, 'staging'

role :app, %w(deploy@syncstaging01.omnipasteapp.com)
role :web, %w(deploy@syncstaging01.omnipasteapp.com)
