module AdhearsionAmqp
  class Plugin < Adhearsion::Plugin
    # Actions to perform when the plugin is loaded
    #
    init :adhearsion_amqp do
      logger.info "AdhearsionAmqp has been loaded"
      ::Adhearsion::CallController.mixin ::AdhearsionAmqp::ControllerMethods
    end

    # Basic configuration for the plugin
    #
    config :adhearsion_amqp do
      greeting "Hello", :desc => "What to use to greet users"
      host "localhost", :desc => "The RabbitMQ host ip"
      queue "call_events", :desc => "The queue to attach to"
      routing_key "call_events", :desc => "The routing key to use for exchange"

    end

    # Defining a Rake task is easy
    # The following can be invoked with:
    #   rake plugin_demo:info
    #
    tasks do
      namespace :adhearsion_amqp do
        desc "Prints the PluginTemplate information"
        task :info do
          STDOUT.puts "AdhearsionAmqp plugin v. #{VERSION}"
        end
      end
    end

  end
end