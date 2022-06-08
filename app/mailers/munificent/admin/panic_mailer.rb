module Munificent
  module Admin
    class PanicMailer < ApplicationMailer
      # Subject can be set in your I18n file at config/locales/en.yml
      # with the following lookup:
      #
      #   en.panic_mailer.missing_key.subject
      #
      def missing_key(donator, game)
        return if User.none?

        @donator = donator
        @game = game

        mail to: User.pluck(:email_address)
      end
    end
  end
end
