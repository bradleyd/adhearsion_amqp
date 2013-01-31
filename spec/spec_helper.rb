require 'adhearsion'
require 'adhearsion_amqp'
require "evented-spec"

RSpec.configure do |config|
  config.color_enabled = true
  config.tty = true

  config.mock_with :mocha
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

