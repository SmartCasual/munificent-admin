module Munificent
  module Admin
    module StateMachineHelper
    module_function

      def aasm_buttons(resource, tag_name: "li")
        resource.aasm.permitted_transitions.each do |transition|
          event = transition.fetch(:event).to_s

          content_for(:aasm_buttons) do
            tag.public_send(tag_name) do
              button_to(
                event.humanize,
                send("#{event}_#{resource.class.name.split('::').last.underscore}_path", resource),
                method: :post,
                data: { confirm: "Are you sure?" },
              )
            end
          end
        end

        content_for(:aasm_buttons).presence
      end

      def define_routes(router, resource_class)
        router.send(:member) do
          resource_class.aasm.events.each do |event|
            router.send(:post, event.to_s)
          end
        end
      end

      def define_actions(controller, resource_class)
        singular_name = resource_class.name.split("::").last.underscore

        resource_class.aasm.events.each do |event|
          controller.define_method(event.name) do
            resource.public_send("#{event.name}!")
            redirect_to(send("#{singular_name}_path", resource),
              notice: "#{event.name.to_s.humanize} was successful",
            )
          end
        end

        nil
      end
    end
  end
end
