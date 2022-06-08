module Munificent
  module Admin
    class UserSession < Authlogic::Session::Base
      login_field :email_address
      record_selection_method :find_by_email_address

      # This is a fairly restrictive configuration
      # because this is an admin application.
      consecutive_failed_logins_limit 5
      encrypt_cookie true
      generalize_credentials_error_messages true
      httponly true
      logout_on_timeout true
      remember_me_for 20.hours
      same_site "Strict"
      single_access_allowed_request_types []
    end
  end
end
