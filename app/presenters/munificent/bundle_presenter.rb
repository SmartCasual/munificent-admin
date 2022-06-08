module Munificent
  class BundlePresenter < Admin::ApplicationPresenter
    delegate(
      %i[
        id
        fundraiser
      ],
    )

    delegate(
      %i[
        ends_at
        starts_at
      ], to: :"record.highest_tier",
    )

    def price
      record.highest_tier&.human_price(symbol: true)
    end

    def state
      tag.span(class: "badge text-bg-#{record.live? ? 'success' : 'secondary'}") do
        record.state.humanize
      end
    end
  end
end
