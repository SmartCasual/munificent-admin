Given("at least one of each type of thing") do
  @current = %I[
    admin
    bundle
    bundle_tier
    donation
    donator
    donator_bundle
    fundraiser
    game
  ].index_with { |factory| create(factory) }
end

Then("the admin should be able to see public information") do
  go_to_admin_games
  expect(page).to have_text(@current[:game].name)
end

Then("the admin should be able to see their own information") do
  expect(page).not_to have_text(@current_user.email_address)

  within ".user" do
    click_on @current_user.name
  end

  expect(page).to have_text(@current_user.email_address)
end

Then("the admin should not be able to modify public information") do
  go_to_admin_game(@current[:game])
  expect(page).not_to have_text("Edit")
end

Then("the admin should be able to modify public information") do
  go_to_admin_game(@current[:game])
  expect(page).to have_text("Edit")
end

Then("the admin should not be able to read donation information") do
  go_to_admin_homepage
  expect(page).not_to have_text("Donations")
  visit munificent_admin.donations_path
  expect(page).to have_current_path(munificent_admin.root_path)
  expect(page).to have_text("You are not authorized to access this page.")
end

Then("the admin should be able to read donation information") do
  go_to_admin_homepage
  expect(page).to have_text("Donations")
  click_on "Donations"
  expect(page).to have_current_path(munificent_admin.donations_path)
end

Then("the admin should not be able to manage admin accounts") do
  go_to_admin_homepage
  expect(page).not_to have_text("Admin users")
  visit munificent_admin.users_path
  expect(page).to have_current_path(munificent_admin.root_path)
  expect(page).to have_text("You are not authorized to access this page.")
end

Then("the admin should be able to manage admin accounts") do
  go_to_users

  click_on @current[:admin].to_s
  expect(page).to have_current_path(munificent_admin.user_path(@current[:admin]))
  click_on "Edit"
  expect(page).to have_current_path(munificent_admin.edit_user_path(@current[:admin]))
end

Then("they should be bounced to the admin login page") do
  expect(page).to have_css("h1", text: "Log in")
end
