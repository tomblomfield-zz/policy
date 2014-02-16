module Policy
  module PolicyObject

    def self.included(base)
      base.class_eval { extend ClassMethods }
    end

    module ClassMethods
      def perform(args = {})
        puts "initialized with #{args.inspect}"
        new(args).tap(&:perform)
      end
    end

    def initialize(context = {})
      @context = context
    end

    def message
      @message || "Unauthorized"
    end

    def allowed?
      @allowed.nil? ? true : @allowed
    end

    def fail!(args = {})
      @message = args[:message]
      @allowed = false
    end

    def context
      @context
    end

    def method_missing(method, *)
      puts "method missing on #{method}"

      if context.respond_to?(method)
        context.send(method)
      elsif context.respond_to?(:fetch)
        context.fetch(method) { super }
      else
        super
      end
    end

    def respond_to_missing?(method, *)
      (context && (context.respond_to?(method) || context.key?(method))) || super
    end
  end
end