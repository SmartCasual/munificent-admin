module Munificent
  class BundleTierPresenter < Admin::ApplicationPresenter
    delegate(
      %i[
        id
        ends_at
        fundraiser
        starts_at
      ],
    )

    def price
      record.human_price(symbol: true)
    end

    def games
      record.bundle_tier_games.map(&:game).map(&:name).join(", ")
    end
  end
end
