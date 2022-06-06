module Munificent
  class CharityPresenter < Admin::ApplicationPresenter
    delegate(
      %i[
        id
        description
      ],
    )

    def fundraisers
      record.fundraisers.map(&:name).join(", ")
    end
  end
end
