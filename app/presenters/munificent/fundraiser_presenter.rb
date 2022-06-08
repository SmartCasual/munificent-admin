module Munificent
  class FundraiserPresenter < Admin::ApplicationPresenter
    delegate(
      %i[
        id
        description
        main_currency
        starts_at
        ends_at
        overpayment_mode
        short_url
        state
      ],
    )

    def state
      tag.span(class: "badge text-bg-#{badge_type}") do
        record.state.humanize
      end
    end

    def overpayment_mode
      record.overpayment_mode.humanize
    end

  private

    def badge_type
      case record.state
      when "inactive"
        "secondary"
      when "active"
        "success"
      when "archived"
        "info"
      else
        "light"
      end
    end
  end
end
