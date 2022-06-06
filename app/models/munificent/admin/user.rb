module Munificent
  module Admin
    class User < Munificent::ApplicationRecord
      include Authenticable

      attr_accessor :password_confirmation
      attr_writer :require_password

      def require_password?
        !!@require_password
      end

      validates :password,
        presence: true,
        confirmation: true,
        length: { minimum: 10 },
        if: :require_password?
      validates :email_address, presence: true

      def has_2sv?
        otp_secret.present?
      end

      def permissions
        if full_access?
          ["full access"]
        else
          [].tap do |perms|
            perms << "data entry" if data_entry?
            perms << "manages users" if manages_users?
            perms << "support" if support?
          end
        end
      end

      def states
        [].tap do |states|
          states << "active" if active?
          states << "approved" if approved?
          states << "confirmed" if confirmed?
        end
      end

      # We may use these later, but for now default them to `true`.
      def active? = true
      def approved? = true
      def confirmed? = true

      def to_s
        name.presence || email_address
      end
    end
  end
end
