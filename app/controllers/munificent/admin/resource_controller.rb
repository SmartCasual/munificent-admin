module Munificent
  module Admin
    class ResourceController < ApplicationController
      abstract!

      cattr_writer :resource_class
      def self.resource_class
        @@resource_class || raise(MissingResourceClassError)
      end

      DEFAULT_ACTIONS = %i[
        index
        show
        new
        create
        edit
        update
        destroy
      ].freeze

      def self.actions(only: DEFAULT_ACTIONS, except: [])
        if (unsupported_actions = (only + except) - DEFAULT_ACTIONS).any?
          raise ArgumentError, "Unsupported actions #{unsupported_actions.join(', ')}"
        end

        selected_actions = (only - except)
        (selected_actions & %i[index show new edit]).each do |action|
          define_method(action) do |&block|
            load_and_authorize_resource(class: self.class.resource_class)
            instance_eval(&block)
          end
        end

        klass = resource_class.constantize

        if klass.respond_to?(:aasm)
          helper StateMachineHelper
          StateMachineHelper.define_actions(self, klass)
        end
      end

    private

      class MissingResourceClassError < StandardError
        def initialize
          super("You must call `self.resource_class=` in your controller")
        end
      end
    end
  end
end
