require "rotp"
require "rqrcode"

module Munificent
  module Admin
    class OTPController < ApplicationController
      skip_authorization_check
      skip_before_action :enforce_2sv

      before_action :require_setup, only: %i[input]
      before_action :prevent_double_setup, only: %i[setup]
      before_action :require_otp_issuer

      def input; end

      def setup
        session[:otp_secret] = ROTP::Base32.random
        totp = ROTP::TOTP.new(session[:otp_secret], issuer: ENV.fetch("OTP_ISSUER", nil))
        @otp_url = totp.provisioning_uri(current_user.email_address)
        @qr_code = RQRCode::QRCode.new(@otp_url).as_svg(standalone: false, module_size: 5)
      end

      def verify
        otp_secret = current_user.otp_secret || session[:otp_secret]
        raise "Missing OTP secret" if otp_secret.blank?

        totp = ROTP::TOTP.new(otp_secret, issuer: ENV.fetch("OTP_ISSUER", nil), after: current_user.last_otp_at)

        if totp.verify(params[:otp_code], drift_behind: 3)
          current_user.otp_secret ||= session[:otp_secret]
          current_user.update(last_otp_at: (session[:last_otp_at] = Time.zone.now))
          session[:otp_secret] = nil

          redirect_to root_path
        elsif current_user.has_2sv?
          redirect_to otp_input_path
        else
          redirect_to otp_setup_path
        end
      end

    private

      def require_setup
        redirect_to otp_setup_path unless current_user&.has_2sv?
      end

      def prevent_double_setup
        redirect_to otp_input_path if current_user&.has_2sv?
      end

      def require_otp_issuer
        raise "Missing OTP issuer" if ENV["OTP_ISSUER"].blank?
      end
    end
  end
end
