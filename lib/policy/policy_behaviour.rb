require 'active_support/inflector'

module Policy
  module PolicyBehaviour

    def self.included(base)
      base.class_eval { extend ClassMethods }
    end

    module ClassMethods
      def policy(policy_sym, args = {})
        before_filter ->(controller) do
          policy_object = policy_class(policy_sym).perform(args)
          controller.unauthorized(policy_object.message) unless policy_object.allowed?
        end, args.select { |k,_| [:only, :except].include?(k) }
      end

      def policy_class(policy_sym)
        (policy_sym.to_s.camelize + "Policy").constantize
      end
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