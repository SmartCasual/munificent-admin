When("an admin adds a bundle") do
  bundle_name = "Test bundle"

  go_to_admin_area "Bundles"
  click_on "New bundle"

  within "fieldset.record" do
    fill_in "Name", with: bundle_name
    select Munificent::Fundraiser.active.first.name, from: "Fundraiser"
  end

  click_on "Save"

  @current_bundle = Munificent::Bundle.find_by!(name: bundle_name)
end

Then("the bundle should appear on the admin bundles list") do
  go_to_admin_area "Bundles"
  expect(page).to have_css("td.col-name", text: @current_bundle.name)
end

Then("the bundle shouldn't appear on the admin bundles list") do
  go_to_admin_area "Bundles"
  expect(page).not_to have_css("td.col-name", text: @current_bundle.name)
end

Then("there should be an admin page for that bundle") do
  go_to_admin_bundle(@current_bundle)
  expect(page).to have_css("h1", text: @current_bundle.name)
end

Given("a bundle priced at {amount}") do |price|
  @current_bundle = create(:bundle, :live, price:)
end

Given("a draft bundle priced at {amount}") do |price|
  @current_bundle = create(:bundle, :draft, price:)
end

Given("a draft empty bundle priced at {amount}") do |price|
  @current_bundle = create(:bundle, :draft, :empty, price:)
end

Given("a bundle") do
  @current_bundle = create(:bundle, :live)
end

Given("a bundle with tiers") do
  @current_bundle = create(:bundle, :live, :tiered)
end

Given(/^a (draft|live) bundle$/) do |state|
  @current_bundle = create(:bundle, state.to_sym)
end

Given(/^a (draft|live) bundle with tiers$/) do |state|
  @current_bundle = create(:bundle, state.to_sym, :tiered)
end

Given("these games:") do |table|
  table.raw.each { |(name)| create(:game, name:) }
end

When("an admin adds these games to the bundle:") do |table|
  @tiers_and_games = table.symbolic_hashes.each.with_object(Hash.new { |h, k| h[k] = [] }) do |row, hash|
    hash[Monetize.parse(row[:tier])] << row[:game]
  end

  add_tiers_and_games_to_bundle(@tiers_and_games,
    bundle: @current_bundle,
    navigate: true,
  )

  click_on "Save"
end

When("an admin edits a game entry") do
  @new_game = create(:game).name
  go_to_admin_bundle(@current_bundle, edit: true)

  page.find("option[selected='selected']", text: @current_bundle.highest_tier.games.first.name)
    .ancestor("select")
    .find("option", text: @new_game)
    .select_option

  click_on "Save"
end

Then("the edits to the game entry should've been saved") do
  go_to_admin_bundle(@current_bundle)
  expect(page).to have_css(".col-games", text: @new_game)
end

Then("the games with their tiers should be on the admin page for that bundle") do
  go_to_admin_bundle(@current_bundle)

  tier_blocks = page.all("table.tiers tbody tr")

  @tiers_and_games.sort.reverse.each.with_index do |(tier_price, games), index|
    within tier_blocks[index] do
      expect(page).to have_css(".col-price", text: tier_price.format(no_cents_if_whole: true))
      expect(page).to have_css(".col-games", text: games.join(", "))
    end
  end
end

When("an admin deletes a game entry") do
  go_to_admin_bundle(@current_bundle, edit: true)

  tier_block = page.first(".tier-form")
  @deleted_game_entry = tier_block.first(".field-game_ids option[selected='selected']").text

  within tier_block do
    unselect @deleted_game_entry
  end

  click_on "Save"
end

Then("the game entry shouldn't be on the admin page for that bundle") do
  go_to_admin_bundle(@current_bundle)
  expect(page).not_to have_css(".col-games", text: @deleted_game_entry)
end

When("an admin edits the bundle") do
  go_to_admin_bundle(@current_bundle, edit: true)
  within ".record" do
    fill_in "Name", with: (@new_name = SecureRandom.uuid)
  end
  click_on "Save"
  @current_bundle.reload
end

Then("the edits to the bundle should've been saved") do
  go_to_admin_bundle(@current_bundle)
  expect(page).to have_css("h1", text: @new_name)
end

When("an admin deletes the bundle") do
  go_to_admin_bundle(@current_bundle)
  click_action "Delete"
end

When("an admin publishes the bundle") do
  go_to_admin_bundle(@current_bundle)
  click_action "Publish"
end

When("an admin retracts the bundle") do
  go_to_admin_bundle(@current_bundle)
  click_action "Retract"
end

When("the user goes to the admin bundles area") do
  visit munificent_admin.bundles_path
end

Then("the bundle should appear on the admin bundles list as {word}") do |state|
  go_to_admin_area "Bundles"
  expect(page).to have_css(".bundle_#{@current_bundle.id} .col-state", text: state.humanize)
end

Then("the bundles list should not have an edit link for that bundle") do
  go_to_admin_area "Bundles"
  expect(page).not_to have_css(".bundle_#{@current_bundle.id} .col-edit")
end

When("an admin attempts to edit the bundle anyway") do
  visit munificent_admin.edit_bundle_path(@current_bundle)
end

Then("the admin should be redirected to the bundle") do
  expect(page).to have_css("h1", text: @current_bundle.name)
  expect(page).to have_css(".notices li", text: "Live bundles cannot be edited")
end

When("an admin changes the price of a game tier within a bundle") do
  go_to_admin_bundle(@current_bundle, edit: true)

  tier = @current_bundle.highest_tier
  @new_price = tier.price + Money.new(100, "USD")

  within ".tier-form:first-of-type" do
    select @new_price.currency.iso_code, from: "Currency"
    fill_in "Price", with: @new_price.format(symbol: false)
  end

  click_on "Save"
end

Then("the price of the game tier should've been saved") do
  go_to_admin_bundle(@current_bundle)
  expect(page).to have_css(".col-price", text: @new_price.format(no_cents_if_whole: true))
end

When("an admin deletes a tier within a bundle") do
  go_to_admin_bundle(@current_bundle, edit: true)

  within page.first(".tier-form") do
    decimals = page.find(".field-human_price input").value
    currency = page.find(".field-price_currency select").value

    @deleted_tier_price = Money.new(decimals, currency)

    check "Delete"
  end

  click_on "Save"
end

Then("the tier shouldn't appear on the admin page for that bundle") do
  go_to_admin_bundle(@current_bundle)
  expect(page).not_to have_css(".col-price", text: @deleted_tier_price.format(no_cents_if_whole: true))
end
