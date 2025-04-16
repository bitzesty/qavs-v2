# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy

Rails.application.config.content_security_policy do |policy|
  # Default to only allowing content from the same origin
  policy.default_src :self

  # Prevent loading of plugins
  policy.object_src :none

  # Scripts only from same origin and with nonces
  policy.script_src :self, :strict_dynamic, :unsafe_inline

  # Styles from same origin and allow inline for bootstrap-sass
  policy.style_src :self, :unsafe_inline

  # Allow images from same origin, HTTPS sources, and data URIs
  policy.img_src :self, :https, :data

  # Allow fonts from same origin and HTTPS sources
  policy.font_src :self, :https

  # Allow AJAX connections to same origin and HTTPS sources
  policy.connect_src :self, :https

  # Allow frames from same origin only
  policy.frame_src :self

  # Report violations to your endpoint (optional)
  # policy.report_uri "/csp-violation-report"
end

# Report violations in development
Rails.application.config.content_security_policy_report_only = Rails.env.development?
