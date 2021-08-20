require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe GroupLeader::CitationsController do
  let!(:group_leader) { create(:group_leader) }
  before do
    sign_in group_leader
  end

  describe "PUT update" do
    it "should update a resource" do
      citation = create(:citation)
      put :update, params: { id: citation.id, citation: { body: 'updated body text'} }
      expect(response).to redirect_to group_leader_root_path
    end

    it "should not update a resource with missing data" do
      citation = create(:citation)
      put :update, params: { id: citation.id, citation: { body: ''} }
      expect(response).not_to be_redirect
    end
  end
end
