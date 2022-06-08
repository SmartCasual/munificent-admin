When("an admin adds a game") do
  game_name = "The Witness"

  go_to_admin_area "Games"
  click_on "New game"
  fill_in "Name", with: game_name
  click_on "Save"

  @current_game = Munificent::Game.find_by!(name: game_name)
end

Then("the game should appear on the admin games list") do
  go_to_admin_area "Games"
  expect(page).to have_css("td.col-name", text: @current_game.name)
end

Then("the game shouldn't appear on the admin games list") do
  go_to_admin_area "Games"
  expect(page).not_to have_css("td.col-name", text: @current_game.name)
end

Then("there should be an admin page for that game") do
  go_to_admin_game(@current_game)
  expect(page).to have_css("h1", text: @current_game.name)
end

Given("a game") do
  @current_game = create(:game)
end

When("an admin edits the game") do
  go_to_admin_game(@current_game, edit: true)
  fill_in "Name", with: (@new_name = SecureRandom.uuid)
  click_on "Save"
  @current_game.reload
end

Then("the edits to the game should've been saved") do
  go_to_admin_game(@current_game)
  expect(page).to have_css("h1", text: @new_name)
end

When("an admin deletes the game") do
  go_to_admin_game(@current_game)
  within ".actions" do
    accept_confirm do
      click_on "Delete"
    end
  end
end

When("the user goes to the admin games area") do
  visit munificent_admin.games_path
end
