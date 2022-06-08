module Munificent
  class GamePresenter < Admin::ApplicationPresenter
    delegate(
      %i[
        id
        description
        created_at
        updated_at
      ],
    )

    def unassigned_keys
      record.keys.unassigned.count
    end

    def assigned_keys
      record.keys.assigned.count
    end
  end
end
