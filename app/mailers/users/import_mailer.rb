class Users::ImportMailer < ApplicationMailer
  def notify_about_release(user_id, raw_token)
    user = User.find(user_id)
    @token = raw_token
    @user = user
    subject = "The Queen's Award for Voluntary Service: Welcome to our new nomination system"
    
    view_mail ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: user.email, subject: subject_with_env_prefix(subject)
  end
end
