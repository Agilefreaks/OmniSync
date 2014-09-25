require 'wamp'
require 'json'
require 'api/root'
require 'api/wamp/engines/omni'

module OmniSync
  class App < WAMP::Server
    def initialize(options = {})
      super(options)
    end

    # rubocop:disable MethodLength
    def self.instance(hostname = '')
      @instance ||= Rack::Builder.new do
        omni_sync_app = OmniSync::App.new(engine: {hostname: hostname, type: :omni})

        def log(text)
          puts "[#{Time.now}] #{text}"
        end

        omni_sync_app.bind(:connect) do |client|
          log "#{client.id} connected"
        end

        omni_sync_app.bind(:prefix) do |client, prefix, uri|
          log "#{client.id} negotiated #{prefix} as #{uri}"
          log "#{client.id} prefixes: #{client.prefixes}"
        end

        omni_sync_app.bind(:subscribe) do |client, topic|
          log "#{client.id} subscribed to #{topic}"
        end

        omni_sync_app.bind(:unsubscribe) do |client, topic|
          log "#{client.id} unsubscribed from #{topic}"
        end

        omni_sync_app.bind(:publish) do |client, topic, data|
          log "#{client.id} published #{data} to #{topic}"
        end

        omni_sync_app.bind(:disconnect) do |client|
          log "#{client.id} disconnected"
        end

        run omni_sync_app
      end.to_app
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, ['wamp'], ping: 25)

        ws.onopen = ->(event) { handle_open(ws, event) }
        ws.onmessage = ->(event) { handle_message(ws, event) }
        ws.onclose = ->(event) { handle_close(ws, event) }

        ws.rack_response
      else
        # call api
        API::Root.call(env)
      end
    end
  end
end
