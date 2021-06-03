require 'rails_helper'
include Warden::Test::Helpers

describe "Admin: Download an application's case summaries PDF", %q{
As an Admin
I want to Print/download an application's case summaries as a pdf
So that I can print and review application's case summaries
} do

  let!(:admin) { create(:admin) }
  let!(:user) { create :user }

  before do
    login_admin(admin)
  end

  describe "Case summary" do
    include_context "admin application case summaries pdf download"
  end
end
