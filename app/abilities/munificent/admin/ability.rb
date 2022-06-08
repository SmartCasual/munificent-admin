module Munificent
  module Admin
    class Ability < ApplicationAbility
      def initialize(user)
        super()

        return unless user.is_a?(User)

        allow_reading_public_info
        allow_reading_self(user)

        if user.data_entry?
          allow_managing_public_info
          allow_managing_keys
        end
        allow_reading_donation_info if user.support?
        allow_managing_user_accounts if user.manages_users?

        can :manage, :all if user.full_access?
      end

    private

      def allow_reading_self(user)
        can :read, :self
        can :read, User, id: user.id
      end

      def allow_managing_public_info
        can :manage, :public_info
        public_classes.each { |klass| can(:manage, klass) }
      end

      def allow_managing_keys
        can :manage, Key
      end

      def allow_reading_donation_info
        can :read, :donation_info
        can :read, DonatorBundle
        can :read, Donation
        can :read, Donator
      end

      def allow_managing_user_accounts
        can :manage, :user_accounts
        can :manage, User
      end
    end
  end
end
