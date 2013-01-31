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

      describe "#greet" do
        it "greets with the correct parameter" do
          subject.expects(:play).once.with("Hello, Luca")
          subject.greet "Luca"
        end
      end

      describe "#publish_message" do
        it "publishes message to amqp" do
          subject.expects(:publish_message).once.with("this is a test message") 
          subject.publish_message("this is a test message")
        end
      end

    end
  end
end
