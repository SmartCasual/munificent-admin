When("an admin adds an admin user") do
  user_email = "#{SecureRandom.uuid}@example.com"

  go_to_users
  click_on "New user"

  fill_in "Name", with: "An Admin"
  fill_in "Email address", with: user_email
  fill_in "Password", with: "password123", exact: true
  fill_in "Password confirmation", with: "password123"

  click_on "Save"

  @created_user = Munificent::Admin::User.find_by!(email_address: user_email)
end

Then("the admin user should appear on the admin users list") do
  go_to_users
  expect(page).to have_css("td.col-email_address", text: @created_user.email_address)
end

Then("the admin user shouldn't appear on the admin users list") do
  go_to_users
  expect(page).not_to have_css("td.col-email_address", text: @created_user.email_address)
end

Then("there should be an admin page for that admin user") do
  go_to_user(@created_user)
  expect(page).to have_css("h1", text: @created_user.name)
end

Given("an admin user") do
  @created_user = create(:admin)
end

When("an admin edits the admin user") do
  go_to_user(@created_user, edit: true)

  fill_in "Name", with: (@new_name = SecureRandom.uuid)
  fill_in "Password", with: (@new_password = SecureRandom.uuid), exact: true
  fill_in "Password confirmation", with: @new_password

  click_on "Save"
  @created_user.reload
end

Then("the edits to the admin user should've been saved") do
  go_to_user(@created_user)
  expect(page).to have_css("h1", text: @new_name)
  expect(@created_user.valid_password?(@new_password)).to eq(true)
end

When("an admin deletes the admin user") do
  go_to_user(@created_user)
  accept_confirm do
    click_on "Delete"
  end
end

When("the user goes to the admin users area") do
  visit munificent_admin.users_path
end
