module Munificent
  module Admin
    class UserPresenter < ApplicationPresenter
      delegate(
        %i[
          id
          email_address
          current_login_at
          login_count
          permissions
          states
        ],
      )

      def permissions
        record.permissions.to_sentence.capitalize
      end

      def states
        record.states.to_sentence.capitalize
      end
    end
  end
end
