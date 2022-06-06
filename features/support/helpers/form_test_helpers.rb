module FormTestHelpers
  def fill_in(*args, fill_options: {}, **kwargs, &block)
    fill_options = { clear: :backspace }.merge(fill_options)
    super(*args, fill_options:, **kwargs, &block)
  end

  def click_action(action)
    within ".actions" do
      accept_confirm do
        click_on action
      end
    end
  end
end

World(FormTestHelpers)
