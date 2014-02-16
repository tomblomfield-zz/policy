require 'spec_helper'

describe Policy::PolicyBehaviour do

  let(:controller_class) { Class.new { include Policy::PolicyBehaviour } }
  let(:controller) { controller_class.new }

  before do
    class CanTestPolicy
      include Policy::PolicyObject
      def perform; end
    end
  end

  before do
    controller_class.stub(:before_filter) { |block, options| block.call(controller) }
  end

  context "with an explicit block" do
    it "calls the method on the controller" do
      controller.should_receive(:current_user)
      controller_class.policy(:can_test) { { user: current_user } }
    end
  end


  context "with implicit controller context" do
    before do
      class CanTestPolicy
        include Policy::PolicyObject
        def perform
          current_user.nil?
        end
      end
    end

    it "calls the method on the controller" do
      controller.should_receive(:current_user)
      controller_class.policy(:can_test)
    end
  end

  context "when allowed" do
    it "does not call unauthorized" do
      controller.should_receive(:unauthorized).never
      controller_class.policy(:can_test)
    end
  end

  context "when not allowed" do
    before do
      class CanTestPolicy
        def perform; fail!; end
      end
    end

    it "calls unauthorized" do
      controller.should_receive(:unauthorized)
      controller_class.policy(:can_test)
    end
  end
end
