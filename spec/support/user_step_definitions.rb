module UserStepDefinitions
  def login_admin(admin)
    visit '/admins/sign_in'
    fill_in 'admin_email', with: admin.email
    fill_in 'admin_password', with: "my98ssdkjv9823kds=2"
    click_button 'Sign in'
  end

  def login_lieutenant(lieutenant)
    visit '/lieutenants/sign_in'
    fill_in 'lieutenant_email', with: lieutenant.email
    fill_in 'lieutenant_password', with: "my98ssdkjv9823kds=2"
    click_button 'Sign in'
  end
end
