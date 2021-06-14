require 'rails_helper'
include Warden::Test::Helpers

describe "Admin: Download an application's feedback PDF", %q{
As an Admin
I want to Print/download an application's feedback as a pdf
So that I can print and review application's feedback
} do

  let!(:admin) { create(:admin) }
  let!(:user) { create :user }

  before do
    login_admin(admin)
  end

  describe "Enterprise Promotion Award" do
    let(:award_type) { :qavs }
    include_context "admin application feedback pdf download"
  end
end
