module WAMP
  module Engines
    class Omni < WAMP::Engines::Memory
      # Creates a new Socket object and adds it as a client.
      # @param websocket [WebSocket] The websocket connection that belongs to the
      #   new client
      # @return [WebSocket] Returns the newly created socket object
      def create_client(websocket)
        client = new_client(websocket)
        @clients[client.id] = client
      end

      private

      def new_client(websocket)
        WAMP::Socket.new(custom_uuid, websocket)
      end

      def custom_uuid
        prefix = (options[:hostname] || '').split(//).last(2).join
        prefix + SecureRandom.uuid
      end
    end
  end
end