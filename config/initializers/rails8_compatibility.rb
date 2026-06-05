# This file provides compatibility shims for libraries that depend on
# deprecated/removed Rails features in Rails 8.0

# Create compatibility modules for code that still requires these
module ActiveSupport
  unless const_defined?(:ProxyObject)
    ProxyObject = ::BasicObject
  end

  unless const_defined?(:BasicObject)
    class BasicObject < ::BasicObject; end
  end

  module Compat
    def self.blank?(obj)
      obj.respond_to?(:empty?) ? obj.empty? : !obj
    end
  end
end

# If JBuilder is being used, provide compatibility methods
if defined?(Jbuilder)
  module JbuilderCompat
    def self.included(base)
      base.class_eval do
        alias_method :_original_blank?, :_blank? if method_defined?(:_blank?)

        def _blank?(value)
          value.respond_to?(:empty?) ? value.empty? : !value
        end
      end
    end
  end

  Jbuilder.send(:include, JbuilderCompat) rescue nil
end

# Create module definitions for classes that have been removed
module ActiveSupport
  module BasicObject
  end
end
