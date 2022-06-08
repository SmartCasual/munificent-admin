module Munificent
  module Admin
    module FormHelper
      def form_for(*args, **kwargs, &)
        super(*args, builder: Munificent::Admin::FormBuilder, **kwargs, &)
      end
    end
  end
end
