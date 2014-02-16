require 'spec_helper'


describe Policy::PolicyObject do

  let(:policy) do
    Class.new do
      include Policy::PolicyObject
      def perform; end
    end
  end

  subject(:policy_object) { policy.perform }

  describe ".perform" do
    subject(:perform) { policy.perform }

    it { should be_instance_of policy }

    it "calls perform on the object" do
      policy.any_instance.should_receive(:perform)
      perform
    end
  end

  describe "#allowed?" do
    it { should be_allowed } # by default

    context "when disallowed" do
      before { policy_object.context.instance_variable_set(:@allowed, false) }

      it { should_not be_allowed }
    end
  end

  describe "fail!" do
    it "disallows the policy" do
      policy_object.fail!
      policy_object.should_not be_allowed
    end

    it "exposes an optional error message" do
      msg = "Permission denied"
      policy_object.fail!(message: msg)
      policy_object.message.should == msg
    end
  end
end