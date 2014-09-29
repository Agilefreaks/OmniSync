set :deploy_to, '/var/www/omnisync'
set :branch, 'staging'

role :app, %w(deploy@syncproduction01.omnipasteapp.com deploy@syncproduction02.omnipasteapp.com)
role :web, %w(deploy@syncproduction01.omnipasteapp.com deploy@syncproduction02.omnipasteapp.com)
