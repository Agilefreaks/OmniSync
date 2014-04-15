role :app, %w(deploy@46.16.191.70)
role :web, %w(deploy@46.16.191.70)

set :deploy_to, '/var/www/omnisync_staging'
set :branch, 'master'

set :puma_workers, 4
