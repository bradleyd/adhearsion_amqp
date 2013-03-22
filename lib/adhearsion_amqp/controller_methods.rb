require 'amqp'

module AdhearsionAmqp
  module ControllerMethods
    mattr_accessor :routing_key, :exchange, :queue
    # creates connection params for AMQP.start
    #
    # @todo find better way use Loquacious::Configuration::Iterator
    # to build Hash dynamically
    def connection_params
        cfg = Adhearsion.config[:adhearsion_amqp]
        logger.info "HASH: #{cfg}"
      { 
        host: Adhearsion.config[:adhearsion_amqp].host,
        port: Adhearsion.config[:adhearsion_amqp].port,
        username: Adhearsion.config[:adhearsion_amqp].username,
        password: Adhearsion.config[:adhearsion_amqp].password
      }
    end

    def que
      queue || Adhearsion.config[:adhearsion_amqp].queue
    end

    def exc
      exchange || Adhearsion.config[:adhearsion_amqp].exchange
    end

    def rk
      routing_key || Adhearsion.config[:adhearsion_amqp].routing_key
    end

    def publish_message(message)
      yield ControllerMethods if block_given?
      logger.info "RK: #{routing_key}"
      AMQP.start(self.connection_params) do |connection|
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
        # @note can be used for consumers
        #queue    = channel.queue(Adhearsion.config[:adhearsion_amqp].queue)

        logger.info "PUBLISHING #{message} to #{self.rk}"
        # create proc that publishes the message
        # @see #defer
        pub = Proc.new do
          logger.info "THREAD: #{Thread.current}"
          exchange.publish(message, 
                           :routing_key => self.rk) do
            connection.disconnect { EM.stop }
          end
        end
        # publish on another thread
        logger.info "THREAD BEFORE DEFER: #{Thread.current}"
        EM.defer(pub)
      end
    end

  end
end
