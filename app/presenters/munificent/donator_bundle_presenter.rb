module Munificent
  class DonatorBundlePresenter < Admin::ApplicationPresenter
    delegate(
      %i[
        id
        bundle
        created_at
        donator
      ],
    )
  end
end
