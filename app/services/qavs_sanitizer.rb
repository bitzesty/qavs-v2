class QavsSanitizer
  ALLOWED_TAGS = %w[
    p b i em strong small
    h1 h2 h3 h4 h5 h6
    ul ol li
    br hr
    div span
    table thead tbody tr td th
    a img
  ].freeze

  ALLOWED_ATTRIBUTES = %w[
    href src alt title
    width height
    class id
    colspan rowspan
    target rel
  ].freeze

  ALLOWED_PROTOCOLS = %w[http https mailto].freeze

  def initialize
    @sanitizer = Rails::Html::SafeListSanitizer.new
  end

  def sanitize(content)
    return content if content.blank?

    # First pass: Remove script and style tags and their content
    content = remove_dangerous_elements(content)

    # Second pass: Basic sanitization with allowed tags and attributes
    scrubber = Rails::Html::PermitScrubber.new
    scrubber.tags = ALLOWED_TAGS
    scrubber.attributes = ALLOWED_ATTRIBUTES
    content = @sanitizer.sanitize(content, scrubber: scrubber)

    # Third pass: Protocol sanitization for href and src attributes
    doc = Nokogiri::HTML.fragment(content)

    # Clean href attributes
    doc.css('a[href]').each do |node|
      href = node['href'].to_s.downcase
      node.remove_attribute('href') unless valid_url?(href)
    end

    # Clean src attributes
    doc.css('img[src]').each do |node|
      src = node['src'].to_s.downcase
      node.remove_attribute('src') unless valid_url?(src, allow_data: true, allow_relative: true)
    end

    # Final pass: Clean up whitespace and format
    cleanup_html(doc.to_html)
  end

  private

  def remove_dangerous_elements(content)
    doc = Nokogiri::HTML.fragment(content)

    # Remove script tags and their content
    doc.css('script').remove

    # Remove style tags and their content
    doc.css('style').remove

    # Remove on* attributes
    doc.css('*').each do |node|
      node.attributes.each do |name, _|
        node.remove_attribute(name) if name.start_with?('on')
      end
    end

    doc.to_html
  end

  def valid_url?(url, allow_data: false, allow_relative: false)
    return true if allow_relative && !url.include?(':')
    return true if allow_data && url.start_with?('data:')
    return true if url.start_with?('/')  # Allow absolute paths
    return true if url.start_with?('./')  # Allow explicit relative paths
    return true if url.start_with?('../')  # Allow parent directory paths

    protocol = url.split(':').first
    return false unless protocol

    ALLOWED_PROTOCOLS.include?(protocol)
  end

  def cleanup_html(html)
    # Preserve original whitespace
    html.gsub(/\n\s+/, "\n")
  end
end
