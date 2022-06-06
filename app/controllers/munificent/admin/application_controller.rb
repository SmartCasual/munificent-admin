module Munificent
  module Admin
    class ApplicationController < ActionController::Base
      before_action :require_login
      before_action :enforce_2sv

      check_authorization

      helper LayoutHelper
      helper FormHelper

      rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_path, alert: exception.message
      end

    protected

      def handle_unverified_request
        raise ActionController::InvalidAuthenticityToken
      end

    private

      def require_login
        redirect_to new_user_session_path unless logged_in?
      end

      def enforce_2sv
        redirect_to otp_input_path unless verified_2sv?
      end

      def current_user_session
        @current_user_session ||= Munificent::Admin::UserSession.find
      rescue Authlogic::Session::Activation::NotActivatedError
        nil
      end
      helper_method :current_user_session

      def current_user
        return @current_user if defined?(@current_user)

        @current_user = current_user_session&.user
      end
      helper_method :current_user

      def current_ability
        @current_ability ||= Ability.new(current_user)
      end

      def logged_in?
        current_user_session.present? && !current_user_session.stale?
      end
      helper_method :logged_in?

      def verified_2sv?
        session[:last_otp_at] && session[:last_otp_at] > 1.day.ago
      end
      helper_method :verified_2sv?
    end
  end
end
