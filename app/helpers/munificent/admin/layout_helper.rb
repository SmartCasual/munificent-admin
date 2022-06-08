module Munificent
  module Admin
    module LayoutHelper
      def nav_link(*args, **kwargs)
        link_to_unless_current(*args, **kwargs) do |text|
          content_tag(:span, text)
        end
      end
    end
  end
end
