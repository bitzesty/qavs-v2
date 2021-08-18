require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe Assessor::ReportsController do
  let!(:assessor) { create(:assessor) }
  let!(:form_answer) { create(:form_answer) }

  before do
    sign_in assessor
  end

  pending "GET index" do
    it "should render template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  pending "GET show" do
    it "renders the show template" do
      get :show, params: { id: 'feedbacks', category: 'trade' }, :format => 'pdf'
      expect(response.content_type).to eq('application/pdf')

      get :show, params: { id: 'case_summaries',category: 'trade' },  :format => 'csv'
      expect(response.content_type).to eq('text/csv')
    end
  end
end
