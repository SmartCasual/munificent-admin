module Munificent
  module Admin
    module NavigationHelpers
      def reload_page
        visit current_path
      end

      def go_to_admin_homepage
        visit munificent_admin.root_path
      end

      def go_to_admin_area(area)
        within ".main-nav" do
          click_on area unless page.has_css?("span", text: area)
        end
      end

      def go_to_admin_games
        go_to_admin_area "Games"
      end

      def go_to_admin_game(game, edit: false)
        game = Game.find_by(name: game) if game.is_a?(String)
        go_to_admin_record(game, within: "Games", edit:)
      end

      def go_to_game_csv_upload(game)
        go_to_admin_game(game)

        click_on "Upload keys via CSV"
        expect(page).to have_text("#{game.name} CSV upload")
      end

      def go_to_admin_bundle(bundle, edit: false)
        go_to_admin_record(bundle, within: "Bundles", edit:)
      end

      def go_to_users
        go_to_admin_area "Admin users"
      end

      def go_to_user(user, edit: false)
        go_to_admin_record(user, within: "Admin users", edit:)
      end

      def go_to_admin_record(record, within:, edit: false)
        go_to_admin_area(within)

        click_on record.name
        click_on "Edit" if edit
      end
    end
  end
end

World(Munificent::Admin::NavigationHelpers)
