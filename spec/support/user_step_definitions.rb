module UserStepDefinitions
  def login_admin(admin)
    # Try direct Warden login first to avoid browser login issues
    login_as(admin, scope: :admin)
    visit '/admin'

    # If redirected to login page, try browser login
    if page.has_field?('admin_email')
      fill_in 'admin_email', with: admin.email
      fill_in 'admin_password', with: "my98ssdkjv9823kds=2"
      click_button 'Sign in'
    end

    # Verify login success - wait for some admin content
    sleep 2
    expect(page).to have_no_content("You need to sign in or create an account before continuing")
  end

  def login_lieutenant(lieutenant)
    # Make sure we're starting fresh
    page.driver.browser.manage.delete_all_cookies rescue nil

    # Make sure the lieutenant has the right password for testing
    lieutenant.update_column(:encrypted_password, Lieutenant.new(password: "my98ssdkjv9823kds=2").encrypted_password)
    lieutenant.update_column(:confirmed_at, Time.now) if lieutenant.confirmed_at.nil?

    # Use direct browser login
    visit destroy_lieutenant_session_path rescue nil
    visit '/lieutenants/sign_in'

    # Fill in the login form
    fill_in 'lieutenant_email', with: lieutenant.email
    fill_in 'lieutenant_password', with: "my98ssdkjv9823kds=2"
    click_button 'Sign in'

    # Wait for login to complete
    sleep 2

    # Verify we're actually logged in
    expect(page).to have_no_content("You need to sign in or create an account before continuing")
  end

  def login_group_leader(group_leader)
    # Try direct Warden login first to avoid browser login issues
    login_as(group_leader, scope: :group_leader)
    visit '/group_leader'

    # If redirected to login page, try browser login
    if page.has_field?('group_leader_email')
      fill_in 'group_leader_email', with: group_leader.email
      fill_in 'group_leader_password', with: "my98ssdkjv9823kds=2"
      click_button 'Sign in'
    end

    # Verify login success - wait for some group leader content
    sleep 2
    expect(page).to have_no_content("You need to sign in or create an account before continuing")
  end
end
