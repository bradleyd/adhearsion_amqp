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

    end
  end
end
