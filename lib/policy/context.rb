require "delegate"

module Policy
  class Context < SimpleDelegator

    def self.build(context = {})
      self === context ? context : new(context.dup)
    end

    def initialize(context = {})
      super(context)
    end

    def allowed?
      @allowed.nil? ? true : @allowed
    end

    def fail!(context = {})
      update(context)
      @allowed = false
    end
  end
end