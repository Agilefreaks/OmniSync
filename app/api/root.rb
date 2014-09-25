module API
  # helpers
  require_relative 'helpers/params_helper'

  # entities
  require_relative 'entities/notification'

  # resources
  require_relative 'resources/version'

  class Root < Grape::API
    version 'v1', using: :path, vendor: 'OmniSync', cascade: false
    prefix 'api'
    format :json

    helpers ParamsHelper

    desc 'Send a notification.', ParamsHelper.auth_headers
    params do
      optional :registration_ids, type: Array, desc: "The registration id's to notify."
      optional :data, desc: 'Payload.'
    end
    post '/notify' do
      payload = declared_params[:data]
      status = OpenStruct.new(number_of_send_notifications: 0)

      registration_id = headers['Ws-Synctoken']
      client = OmniSync::App.instance.engine.clients[registration_id]
      topic_uri = registration_id

      if client
        OmniSync::App.instance.engine.create_event(client, topic_uri, payload, false, nil)
        OmniSync::App.instance.trigger(:publish, client, topic_uri, payload, false, nil)
        status.number_of_send_notifications += 1
      end

      present status, with: API::Entities::Notification
    end

    mount API::Resources::Version

    base_paths = {
        'development' => 'http://localhost:9293',
        'staging' => 'https://syncstaging.omnipasteapp.com'
    }

    add_swagger_documentation(
        api_version: 'v1',
        mount_path: 'doc',
        hide_documentation_path: true,
        base_path: base_paths[ENV['RACK_ENV']]
    )
  end
end
