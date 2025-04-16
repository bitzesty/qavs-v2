module ContentValidatable
  extend ActiveSupport::Concern

  included do
    # Maximum length for general text content (64KB)
    MAX_CONTENT_LENGTH = 65_536

    # Maximum length for titles or short text (255 chars)
    MAX_TITLE_LENGTH = 255

    # Minimum length for meaningful content
    MIN_CONTENT_LENGTH = 2

    # Basic HTML pattern to detect potentially malicious content
    SUSPICIOUS_PATTERNS = [
      /<script/i,                    # Script tags
      /javascript:/i,                # JavaScript protocol
      /data:/i,                      # Data protocol
      /vbscript:/i,                  # VBScript protocol
      /onclick/i,                    # onclick handlers
      /onerror/i,                    # onerror handlers
      /onload/i,                     # onload handlers
      /onmouseover/i,                # onmouseover handlers
      /&#x/i,                        # Hex encoded chars
      /eval\s*\(/i,                  # eval() function
      /document\.cookie/i,           # Cookie access
      /document\.write/i,            # document.write
      /localStorage/i,               # localStorage access
      /sessionStorage/i,             # sessionStorage access
      /new\s+Function/i              # Function constructor
    ].freeze

    private

    def validate_content_length(content, field_name, max_length = MAX_CONTENT_LENGTH)
      if content.blank? || content.length < MIN_CONTENT_LENGTH
        errors.add(field_name, "is too short (minimum is #{MIN_CONTENT_LENGTH} characters)")
      elsif content.length > max_length
        errors.add(field_name, "is too long (maximum is #{max_length} characters)")
      end
    end

    def validate_content_safety(content, field_name)
      SUSPICIOUS_PATTERNS.each do |pattern|
        if content =~ pattern
          errors.add(field_name, "contains potentially unsafe content")
          break
        end
      end
    end

    def sanitize_content(content)
      QavsSanitizer.new.sanitize(content)
    end
  end
end
