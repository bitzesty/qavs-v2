class FormLink
  include ActiveModel::Model

  attr_reader :link, :description, :position

  validates :link, :description, presence: true
  validates :link, length: { maximum: 500 }

  # Should be 100 words maximum
  validates :description, length: {
    maximum: 100,
    tokenizer: lambda { |str| str.split }
  }

  def initialize(attrs={})
    attrs.each do |key, value|
      instance_variable_set("@#{key}", value.to_s.strip)
    end
  end
end
