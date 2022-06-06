if Rails.env.development? || %w[1 true].include?(ENV.fetch("FORCE_SEEDS", nil))
  require "munificent/seeds"
  require "munificent/admin/seeds"
  Munificent::Seeds.run
  Munificent::Admin::Seeds.run
end
