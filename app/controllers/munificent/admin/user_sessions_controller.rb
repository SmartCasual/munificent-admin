module Munificent
  module Admin
    class UserSessionsController < ApplicationController
      skip_authorization_check

      skip_before_action :require_login, only: %i[new create]
      skip_before_action :enforce_2sv

      def new
        @user_session = UserSession.new
      end

      def create
        @user_session = UserSession.new(user_session_params.to_h)

        if @user_session.save
          redirect_to root_path
        else
          flash[:alert] = @user_session.errors.full_messages.join(", ")
          redirect_to new_user_session_path
        end
      end

      def destroy
        current_user_session.destroy

        redirect_to new_user_session_path
      end

    private

      def user_session_params
        params.require(:user_session).permit(
          *%i[
            email_address
            password
            password_confirmation
            remember_me
          ],
        )
      end
    end
  end
end
