class QavsSanitizer < Rails::Html::PermitScrubber
  def initialize
    super
    self.tags = %w( p )
  end
end
