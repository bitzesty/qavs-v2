require 'rails_helper'

RSpec.describe QavsSanitizer do
  let(:sanitizer) { QavsSanitizer.new }

  # Helper to normalize HTML for comparison
  def normalize_html(html)
    # Remove all whitespace between tags
    html = html.gsub(/>\s+</, '><')
    # Normalize whitespace within text nodes
    html = html.gsub(/\s+/, ' ')
    # Remove leading/trailing whitespace
    html.strip
  end

  describe '#sanitize' do
    context 'with nil or blank content' do
      it 'returns nil for nil content' do
        expect(sanitizer.sanitize(nil)).to be_nil
      end

      it 'returns empty string for blank content' do
        expect(sanitizer.sanitize('')).to eq('')
        expect(sanitizer.sanitize(' ')).to eq(' ')
      end
    end

    context 'with allowed HTML elements' do
      it 'allows basic text formatting' do
        input = '<p>Hello <strong>World</strong>!</p>'
        expect(normalize_html(sanitizer.sanitize(input))).to eq(normalize_html(input))
      end

      it 'allows headings' do
        input = '<h1>Title</h1><h2>Subtitle</h2>'
        expect(normalize_html(sanitizer.sanitize(input))).to eq(normalize_html(input))
      end

      it 'allows lists' do
        input = '<ul><li>Item 1</li><li>Item 2</li></ul>'
        expect(normalize_html(sanitizer.sanitize(input))).to eq(normalize_html(input))
      end

      it 'allows links with safe attributes' do
        input = '<a href="https://example.com" title="Example">Link</a>'
        expect(normalize_html(sanitizer.sanitize(input))).to eq(normalize_html(input))
      end

      it 'allows images with safe attributes' do
        input = '<img src="image.jpg" alt="Test" width="100" height="100">'
        expect(normalize_html(sanitizer.sanitize(input))).to eq(normalize_html(input))
      end
    end

    context 'with disallowed HTML elements' do
      it 'removes script tags' do
        input = '<p>Hello</p><script>alert("XSS")</script>'
        expect(normalize_html(sanitizer.sanitize(input))).to eq(normalize_html('<p>Hello</p>'))
      end

      it 'removes onclick attributes' do
        input = '<a href="/" onclick="alert(\'XSS\')">Click me</a>'
        expect(normalize_html(sanitizer.sanitize(input))).to eq(normalize_html('<a href="/">Click me</a>'))
      end

      it 'removes style tags' do
        input = '<style>body { background: red; }</style><p>Hello</p>'
        expect(normalize_html(sanitizer.sanitize(input))).to eq(normalize_html('<p>Hello</p>'))
      end
    end

    context 'with XSS attack patterns' do
      it 'sanitizes javascript: protocol' do
        input = '<a href="javascript:alert(\'XSS\')">Click me</a>'
        expect(normalize_html(sanitizer.sanitize(input))).to eq(normalize_html('<a>Click me</a>'))
      end

      it 'sanitizes data: protocol' do
        input = '<a href="data:text/html;base64,PHNjcmlwdD5hbGVydCgnWFNTJyk8L3NjcmlwdD4=">Click me</a>'
        expect(normalize_html(sanitizer.sanitize(input))).to eq(normalize_html('<a>Click me</a>'))
      end

      it 'removes embedded SVG with script' do
        input = '<svg><script>alert("XSS")</script></svg>'
        expect(sanitizer.sanitize(input)).to be_blank
      end

      it 'sanitizes nested XSS attempts' do
        input = '<div><img src="x" onerror="alert(\'XSS\')" /><script>eval("alert(1)")</script></div>'
        expect(normalize_html(sanitizer.sanitize(input))).to eq(normalize_html('<div><img src="x"></div>'))
      end
    end

    context 'with complex HTML structures' do
      it 'maintains allowed nested structures' do
        input = '''
          <div class="content">
            <h1>Article Title</h1>
            <p>This is a <strong>very</strong> <em>important</em> paragraph.</p>
            <ul>
              <li>First item with <a href="https://example.com">link</a></li>
              <li>Second item with <img src="image.jpg" alt="test"></li>
            </ul>
          </div>
        '''.strip
        expect(normalize_html(sanitizer.sanitize(input))).to eq(normalize_html(input))
      end

      it 'cleans complex XSS attempts while preserving valid content' do
        input = '''
          <div>
            <h1>Welcome</h1>
            <p onclick="alert(1)">Text</p>
            <script>alert("XSS")</script>
            <img src="valid.jpg" onerror="alert(1)" />
            <a href="javascript:alert(1)">Link</a>
          </div>
        '''.strip
        expected = '''
          <div>
            <h1>Welcome</h1>
            <p>Text</p>
            <img src="valid.jpg">
            <a>Link</a>
          </div>
        '''.strip
        expect(normalize_html(sanitizer.sanitize(input))).to eq(normalize_html(expected))
      end
    end
  end
end
