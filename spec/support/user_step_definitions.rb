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

  def login_group_leader(group_leader)
    visit '/group_leaders/sign_in'
    fill_in 'group_leader_email', with: group_leader.email
    fill_in 'group_leader_password', with: "my98ssdkjv9823kds=2"
    click_button 'Sign in'
  end
end
