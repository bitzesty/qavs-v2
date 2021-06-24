require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe Admin::UsersController do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user, confirmed_at: nil) }

  before do
    sign_in admin
  end

  describe "PATCH log_in" do
    it "confirms the user" do
      patch :log_in, params: { id: user.id }

      expect(assigns(:resource)).to eq(user)
      expect(response).to redirect_to dashboard_url
      expect(user.reload.confirmed_at).not_to be_nil
    end
  end
end
