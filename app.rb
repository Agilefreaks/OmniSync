require 'wamp'
require 'json'

class Application1 < WAMP::Server
  include SimpleRouter::DSL

  def initialize(options = {})
  	super(options)
  end

  get '/' do |context, data|
    data.to_json
  end

  post '/' do |context, data|
    puts 'posted data ' + data.inspect
    sender_id = data['registration_id']
    event_data = data['event']
    client = context.engine.clients[sender_id]
    topic_uri = event_data['topic_uri']
    payload = event_data['data']
    
    puts 'topic_uri = ' + topic_uri.inspect
    puts 'payload = ' + payload.inspect

    if (client)
      context.engine.create_event(client, topic_uri, payload, false, nil)
      context.trigger(:publish, client, topic_uri, payload, false, nil)
    end

    data.to_json
  end
end

App = Application1.new

def log(text)
  puts "[#{Time.now}] #{text}"
end

App.bind(:connect) do |client, clients|
  log "#{client.id} connected"
end

App.bind(:prefix) do |client, prefix, uri|
  log "#{client.id} negotiated #{prefix} as #{uri}"
  log "#{client.id} prefixes: #{client.prefixes.to_s}"
end

App.bind(:subscribe) do |client, topic|
  log "#{client.id} subscribed to #{topic}"
end

App.bind(:unsubscribe) do |client, topic|
  log "#{client.id} unsubscribed from #{topic}"
end

App.bind(:publish) do |client, topic, data|
  log "#{client.id} published #{data} to #{topic}"
end

App.bind(:disconnect) do |client|
  log "#{client.id} disconnected"
end