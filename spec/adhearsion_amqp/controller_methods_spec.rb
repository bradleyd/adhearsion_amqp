require 'spec_helper'

module AdhearsionAmqp
  describe ControllerMethods do
    describe "mixed in to a CallController" do

      class TestController < Adhearsion::CallController
        include AdhearsionAmqp::ControllerMethods
      end

      let(:mock_call) { mock 'Call' }

      subject do
        TestController.new mock_call
      end

      describe "#publish_message" do
        it "publishes message to amqp" do
          subject.expects(:publish_message).once.with("this is a test message") 
          subject.publish_message("this is a test message")
        end

      end

      describe "#connection_params" do
        let(:connection_hash) { 
          {:host=>"localhost", 
           :port=>5672, 
           :username=>"guest", 
           :password=>"guest"} 
        }

        it "should return connection params from config" do
          #subject.expects(:connection_params).returns(connection  
          subject.connection_params.should eq(connection_hash)
        end
      end

      describe "using amqp hooks" do
        include EventedSpec::AMQPSpec

        default_timeout 0.5

        amqp_before do
          AMQP.connection.should_not be_nil
        end

        let(:data) { "Test string" }

        it "should publish data from connection params" do
          AMQP::Channel.new do |channel, _|
            exchange = channel.direct("amqp-test-exchange")
            queue = channel.queue("amqp-test-queue").bind(exchange)
            queue.subscribe do |hdr, msg|
              hdr.should be_an AMQP::Header
              msg.should == data
              done { queue.unsubscribe; queue.delete }
            end
            EM.add_timer(0.2) do
              exchange.publish data
            end
          end
        end
      end

    end
  end
end
