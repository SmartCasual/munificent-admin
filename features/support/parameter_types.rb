ParameterType(
  name: "amount",
  regexp: /-?[#{Munificent::Currency::SUPPORTED_CURRENCY_SYMBOLS.join}]\d+(?:\.\d{2})?/,
  transformer: -> (amount) {
    Monetize.parse(amount)
  },
)
