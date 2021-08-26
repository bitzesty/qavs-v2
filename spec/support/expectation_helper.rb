module ExpectationHelper
  def expect_to_be_accessible
    expect(page).to be_axe_clean.according_to :wcag2a
  end

  def expect_to_see(content)
    expect(page).to have_content content
  end

  def expect_to_see_no(content)
    expect(page).to_not have_content content
  end
end
