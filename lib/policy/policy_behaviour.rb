require 'active_support/inflector'

module Policy
  module PolicyBehaviour

    def self.included(base)
      base.class_eval { extend ClassMethods }
    end

    module ClassMethods
      def policy(policy_sym, args = {}, &block)
        before_filter ->(controller) do
          if block_given?
            policy_object = policy_class(policy_sym).perform(controller.instance_eval(&block))
          else
            policy_object = policy_class(policy_sym).perform(controller)
          end

          controller.unauthorized(policy_object.message) unless policy_object.allowed?
        end, args
      end

      def policy_class(policy_sym)
        (policy_sym.to_s.camelize + "Policy").constantize
      end
    end

    def policy_class(sym)
      self.class.policy_class(sym)
    end

    def unauthorized(message)
      respond_to do |format|
        format.html { redirect_to :back, error: message }
        format.json do
          render json: { status: :unauthorized, errors: [message] }
        end
      end
    end
  end
end