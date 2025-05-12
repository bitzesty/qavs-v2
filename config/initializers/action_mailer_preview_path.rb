require 'action_mailer/base'

# Handle preview_path= calls by redirecting them to preview_paths=
ActionMailer::Base.singleton_class.alias_method :preview_path=, :preview_paths= unless ActionMailer::Base.respond_to?(:preview_path=)

# Configure preview paths
preview_path = Rails.root.join('spec/mailers/previews')
FileUtils.mkdir_p(preview_path)
Rails.application.config.action_mailer.preview_paths = [preview_path]
Rails.application.config.action_mailer.show_previews = true
