Given("an admin user without 2SV enabled") do
  @user = create(:admin, :without_2sv)
end

When("the admin user tries to log in") do
  log_in_as(@user, expect_failure: true)
end

Then("they should be redirected to set up 2SV") do
  expect(page).to have_css("h1", text: "Set up 2SV")
end

When("they set up 2SV") do
  @user.update(otp_secret: ROTP::Base32.random)
end

Then("the admin should be able to log in") do
  complete_2sv(@user.otp_secret)
  expect(page).to have_css("h1", text: "Dashboard")
end
