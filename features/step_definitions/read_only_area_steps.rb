Given(/^a (donator bundle|donation|donator)$/) do |model_name|
  @current_model = create(model_name.tr(" ", "_").to_sym)
end

Then(/^the (donator bundle|donation|donator)'s (\w+) should appear on the admin (?:donator bundle|donation|donator)s? list$/) do |model_name, attribute|
  model_name = case model_name
  when "donator bundle"
    "Assigned bundles"
  else
    model_name.tr(" ", "_").titleize.pluralize
  end

  go_to_admin_area(model_name)
  expect(page).to have_css("td.col-#{attribute}", text: @current_model.send(attribute))
end

When(/^the user goes to the admin (donator bundle|donation|donator)s? area$/) do |model_name|
  visit munificent_admin.send("#{model_name.tr(' ', '_')}s_path")
end
