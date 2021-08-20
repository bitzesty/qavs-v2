module CustomSelect
  def custom_select(name, options = {})
    from = options[:from]
    label = find("label", text: from)
    id = label[:for]
    input = find("input", id: id)
    input.click # open select

    within "##{id}__listbox" do
      find("li", text: name).click
    end
  end
end


RSpec.configure do |config|
  config.include CustomSelect, type: :feature
end
