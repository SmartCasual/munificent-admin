module Munificent
  module Admin
    class Seeds
      def self.run
        puts "Creating admin user admin@example.com" # rubocop:disable Rails/Output
        Munificent::Admin::User.create!(
          name: "Test User",
          email_address: "admin@example.com",
          password: "password123",
          password_confirmation: "password123",
          full_access: true,
          # otpauth://totp/Jingle%20Jam%20%28Staging%29:admin%40example.com?secret=EEKMC5VPZQDAD2XT27DRKIWXAJTHDKVC&issuer=Jingle%20Jam%20%28Staging%29
          otp_secret: "EEKMC5VPZQDAD2XT27DRKIWXAJTHDKVC",
          last_otp_at: Time.zone.now,
        )
      end
    end
  end
end
