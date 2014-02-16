module Policy::PolicyObject

  def self.included(base)
    base.class_eval { extend ClassMethods }
  end

  module ClassMethods
    def perform(args = {})
      new(args).tap(&:perform)
    end
  end

  def initialize(context = {})
    @context = Policy::Context.build(context)
  end

  def allowed?
    context.allowed?
  end

  def fail!(*args)
    context.fail!(*args)
  end

  def message
    context.key?(:message) ? super : "Unauthorized"
  end

  def context
    @context
  end

  def method_missing(method, *)
    context.fetch(method) { context.fetch(method.to_s) { super } }
  end

  def respond_to_missing?(method, *)
    (context && (context.key?(method) || context.key?(method.to_s))) || super
  end

end