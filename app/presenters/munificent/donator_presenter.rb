module Munificent
  class DonatorPresenter < Admin::ApplicationPresenter
    delegate(
      %i[
        id
        chosen_name
        created_at
        email_address
      ],
    )
  end
end
