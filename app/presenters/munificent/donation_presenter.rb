module Munificent
  class DonationPresenter < Admin::ApplicationPresenter
    delegate(
      %i[
        id
        amount
        created_at
        curated_streamer
        donated_by
        donator_name
        fundraiser
        message
      ],
    )

    def state
      tag.span(class: "badge text-bg-#{badge_type}") do
        record.state.humanize
      end
    end

  private

    def badge_type
      case record.state
      when "pending"
        "secondary"
      when "paid"
        "info"
      when "cancelled"
        "danger"
      when "fulfilled"
        "success"
      else
        "light"
      end
    end
  end
end
