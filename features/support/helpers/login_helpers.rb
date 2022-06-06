module LoginHelpers
  def log_in_admin_with(email_address, otp_secret:, navigate: true, expect_failure: false)
    visit "/login" if navigate

    fill_in "Email address", with: email_address
    fill_in "Password", with: "password123"
    click_on "Log in"

    complete_2sv(otp_secret) if otp_secret.present?

    unless expect_failure
      @current_user = Munificent::Admin::User.find_by!(email_address:)
      expect(page).to have_css(".main-nav .user a", text: @current_user.name)
      @current_user
    end
  end

  def complete_2sv(otp_secret)
    fill_in "112233", with: ROTP::TOTP.new(otp_secret).at(Time.zone.now)
    click_on "Verify"
  end

  def log_in_as(user_or_factory, traits: nil, **kwargs)
    user = case user_or_factory
    when Symbol
      create(user_or_factory, *traits)
    when Munificent::Admin::User
      user_or_factory
    else
      raise ArgumentError, "Please provide an `Admin::User` instance, or a factory name."
    end

    log_in_admin_with(user.email_address, otp_secret: user.otp_secret, **kwargs)

    user
  end

  def ensure_logged_in(as: :admin, **kwargs)
    log_in_as(as, **kwargs)
  end

  def log_out(navigate: true)
    go_to_homepage if navigate
    click_on "Log out"
  end

  def ensure_logged_out
    log_out if logged_in?
  end

  def logged_in?
    page.has_button?("Log out")
  end
end

World(LoginHelpers)
