require 'amqp'
module AdhearsionAmqp
  module ControllerMethods

    def publish(message)
      AMQP.start do |connection|
        logger.debug "Connected to RabbitMQ. Running #{AMQP::VERSION} version of the gem..."
        channel = AMQP::Channel.new(connection)

        # re-connect on error
        connection.on_tcp_connection_loss do |conn, settings|
          logger.error "[network failure] Trying to reconnect..."
          conn.reconnect(false, 2)
        end
        # bail if we have a channel error
        channel.on_error do |ch, channel_close|
          logger.error "Channel-level error: #{channel_close.reply_text}, shutting down..."
          connection.close { EventMachine.stop }
        end

        exchange = channel.direct("", :durable => true)
        queue    = channel.queue(Adhearsion.config[:adhearsion_amqp].queue)

        # create proc that publishes the message
        # @note will call this later in #defer
        pub = Proc.new do
          exchange.publish(message, :routing_key => Adhearsion.config[:adhearsion_amqp].routing_key) do
            connection.disconnect { EM.stop }
          end
        end
        # publish on another thread
        EM.defer(pub)
      end
    end

  end
end
