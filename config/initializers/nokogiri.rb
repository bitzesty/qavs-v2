# Only define the constant if it hasn't been defined yet
unless defined?(Nokogiri::Gumbo::DEFAULT_MAX_TREE_DEPTH)
  Nokogiri::Gumbo::DEFAULT_MAX_TREE_DEPTH = -1
end
