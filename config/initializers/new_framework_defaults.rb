# Be sure to restart your server when you modify this file.
#
# This file contains migration options to ease your Rails 5.0 upgrade.
#
# Once upgraded flip defaults one by one to migrate to the new default.
#
# Read the Rails 5.0 release notes for more info on each option.

# Enable per-form CSRF tokens. Previous versions had false.
Rails.application.config.action_controller.per_form_csrf_tokens = true

# Enable origin-checking CSRF mitigation. Previous versions had false.
Rails.application.config.action_controller.forgery_protection_origin_check = false

# Rails 8.1 timezone configuration - opt in to new behavior
Rails.application.config.active_support.to_time_preserves_timezone = :zone

# Require `belongs_to` associations by default. Previous versions had false.
Rails.application.config.active_record.belongs_to_required_by_default = false
