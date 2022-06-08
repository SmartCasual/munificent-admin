Given("the admin has individual permissions") do
  @admin = create(:admin,
    data_entry: true,
    manages_users: true,
    support: true,
    full_access: false,
  )
end

Then("a list of the permissions appears on the admin users page") do
  log_in_as(@admin)
  visit munificent_admin.users_path
  expect(page).to have_content("Data entry, manages users, and support")
end

When("the admin is given full access") do
  @admin.update(full_access: true)
end

Then(%(the permissions list shows "Full access")) do
  visit munificent_admin.users_path
  expect(page).to have_content("Full access")
  expect(page).not_to have_content("manages users")
end

Given("an admin with no permissions") do
  @subject_admin = create(:admin,
    data_entry: false,
    manages_users: false,
    support: false,
    full_access: false,
  )
end

Given("an admin with permission to manage users") do
  @managing_admin = create(:admin,
    manages_users: true,
    full_access: false,
  )
end

Then("the managing admin should be able to grant the other admin new permissions") do
  log_in_as(@managing_admin)
  visit munificent_admin.users_path

  click_on @subject_admin.to_s
  click_on "Edit"

  check "Manages users"
  click_on "Save"
  expect(page).to have_content("User saved")

  visit munificent_admin.users_path
  within(".user_#{@subject_admin.id}") do
    expect(page).to have_content("Manages users")
  end
end

Then("the managing admin should be able to remove permissions from the other admin") do
  click_on @subject_admin.to_s
  click_on "Edit"

  uncheck "Manages users"
  click_on "Save"
  expect(page).to have_content("User saved")

  visit munificent_admin.users_path
  within(".user_#{@subject_admin.id}") do
    expect(page).not_to have_content("Manages users")
  end
end
