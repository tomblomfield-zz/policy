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
