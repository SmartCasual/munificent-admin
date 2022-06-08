module Munificent
  module Admin
    module BundleTestHelpers
      def add_tiers_and_games_to_bundle(tiers_and_games, bundle:, navigate: false)
        go_to_admin_bundle(bundle, edit: true) if navigate

        tiers_and_games.sort.reverse.each do |tier_price, games|
          # We don't want to create a second tier if one already exists
          # at the same price point.
          tier_block = begin
            page
              .find(".field-human_price input[value='#{tier_price.format(no_cents_if_whole: true, symbol: false)}']")
              .ancestor(".tier-form")
          rescue Capybara::ElementNotFound
            ".tier-form.new-tier"
          end

          within(tier_block) do
            if tier_block.is_a?(String)
              select tier_price.currency.iso_code, from: "Currency"
              fill_in "Price", with: tier_price.format(symbol: false)
            end

            games.each do |game|
              select game, from: "Games"
            end
          end

          click_on "Save"
        end
      end
    end
  end
end

World(Munificent::Admin::BundleTestHelpers)
