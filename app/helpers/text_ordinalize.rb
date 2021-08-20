class TextOrdinalize
  def initialize(value)
    @value = value
  end

  def text_ordinalize
    ordinalize_mapping[@value] || @value.ordinalize
  end

  private

  def ordinalize_mapping
    [nil, "first", "second"]
  end
end
